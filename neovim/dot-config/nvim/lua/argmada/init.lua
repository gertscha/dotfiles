-- Argmada.nvim
-- A small-ish Harpoon alternative

---@class ArgMarkElement
---@field argname string
---@field loaded boolean
---@field last_line integer
---@field markindex integer
---@field argindex integer

---@class ArgmadaState
---@field savefilename string?
---@field current integer?
---@field marks table<integer, ArgMarkElement>

---@class ArgmadaConfig
---@field enable_autosave boolean
---@field append_to_end boolean
---@field ui_after_padding integer
---@field ui_width integer
---@field cleanup_days_limit integer
---@field mark_keybind_max_index integer
---@field keep_default_binds boolean
---@field keep_default_ui_binds boolean

---@class ArgmadaFunctions
---@field save_state function
---@field load_state function
---@field mark function
---@field unmark function
---@field select function
---@field select_next function
---@field select_prev function
---@field select_via_ui function
---@field open_ui function
---@field close_ui function
---@field toggle_ui function

---@class ArgmadaPlugin
---@field init function
---@field func ArgmadaFunctions
---@field state ArgmadaState
---@field config ArgmadaConfig
---@field plugin_loaded boolean
---@field state_dir string
---@field popup_win integer?
---@field popup_buf integer?
---@field augroup integer
---@field ns_id integer
---@field ui_extmarks table<integer, ArgMarkElement>

---@type ArgmadaConfig
local default_config = {
  enable_autosave = true,
  ui_after_padding = 3,
  ui_width = 80,
  append_to_end = false,
  cleanup_days_limit = 60,
  -- the last three need to be changed manually in plugin/argmada.lua if the
  -- default needs to be changed (here only as reference)
  mark_keybind_max_index = 4,
  keep_default_binds = true,
  keep_default_ui_binds = true,
}

---@type ArgmadaPlugin
local M = {
  init = nil, ---@diagnostic disable-line:assign-type-mismatch
  func = {}, ---@diagnostic disable-line:missing-fields
  config = {}, ---@diagnostic disable-line:missing-fields
  plugin_loaded = false,
  state = {
    savefilename = nil,
    current = nil,
    marks = {},
  },
  popup_win = nil,
  popup_buf = nil,
  -- the augroup is first created with clear in plugin/argmada.lua
  augroup = vim.api.nvim_create_augroup('Argmada.au', { clear = true }),
  state_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'argmada'),
  ns_id = vim.api.nvim_create_namespace('argmada_ui'),
  hl_ns_id = vim.api.nvim_create_namespace('argmada_ui_hl'),
  ui_extmarks = {},
}

--- enable debug messages
local _debug = false
local _debug_ui = false

---
--- Internal Functions
---

local msg_level_map = {
  ['debug'] = vim.log.levels.DEBUG,
  ['info'] = vim.log.levels.INFO,
  ['err'] = vim.log.levels.ERROR,
  ['warn'] = vim.log.levels.WARN,
}
local function notify(msg, level)
  vim.notify(msg, msg_level_map[level], { title = 'Argmada' })
end

--- Get the pretty string of a MarkElement
---@param mark ArgMarkElement
---@return string
local function print_entry(mark)
  local relative_name = vim.fn.fnamemodify(mark.argname, ':.')
  return string.format('%i %s', mark.markindex, relative_name)
end

--- Get the maximum markindex
---@param marks table<integer, ArgMarkElement>
---@return integer
local function get_max_mark_index(marks)
  local max_idx = 0
  for k, _ in pairs(marks) do
    if k > max_idx then max_idx = k end
  end
  return max_idx
end

--- determine the save file name (based on cwd)
---@return string?
local function get_save_file_name()
  local basedir = vim.uv.cwd()
  if type(basedir) ~= 'string' then
    notify('Cannot determine save file name (uv.cwd() failed)', 'err')
    return nil
  end
  local strip_home = vim.fn.fnamemodify(basedir, ':~')
  local basename = 'f' .. strip_home:gsub('[\\/:]', '-') .. '-state.json'
  local path = vim.fs.joinpath(M.state_dir, basename)
  return path
end

--- Clean up old state files that haven't been modified in X days
--- Uses a tag file to do the check at most once every 24h
local function garbage_collect()
  if _debug then notify('Called garbage_collect()', 'debug') end
  -- special case X=0 means disabled
  if M.config.cleanup_days_limit == 0 then return end
  local tag_file = vim.fs.joinpath(M.state_dir, 'gc_tag')
  if vim.fn.isdirectory(M.state_dir) == 0 then vim.fn.mkdir(M.state_dir, 'p') end

  -- wait at least 24h before checking again
  local tag_stat = vim.uv.fs_stat(tag_file)
  local now = os.time()
  if tag_stat and (now - tag_stat.mtime.sec) < 86400 then return end

  if _debug then notify('Checking for garbage', 'debug') end
  local handle = vim.uv.fs_scandir(M.state_dir)
  if not handle then return end
  local limit_sec = M.config.cleanup_days_limit * 86400
  while true do
    local name, _ = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if name:match('%-state.json$') then
      local path = vim.fs.joinpath(M.state_dir, name)
      local stat = vim.uv.fs_stat(path)
      if stat and (now - stat.mtime.sec) > limit_sec then
        os.remove(path)
        if _debug then notify('GC removed ' .. name, 'debug') end
      end
    end
  end
  local f = io.open(tag_file, 'w')
  if f then
    f:write('auto-gen')
    f:close()
  end
end

--- Apply the plugin state to the argument list
local function apply_state()
  if _debug then notify('Called apply_state()', 'debug') end
  -- clear current arglist and rebuild it, sync "physical" state back into the argindex
  vim.cmd('%argdelete')
  local physical_index = 1
  for _, entry in pairs(M.state.marks) do
    if entry then
      local safe_name = vim.fn.fnameescape(entry.argname)
      vim.cmd('$argadd ' .. safe_name)
      entry.argindex = physical_index
      physical_index = physical_index + 1
    end
  end
end

--- Sync the UI buffer state to plugin state using extmarks
local function sync_ui()
  if _debug_ui then notify('Called Sync()', 'debug') end
  if not (M.popup_win and vim.api.nvim_win_is_valid(M.popup_win)) then return end

  -- Collect the state info from the UI buffer
  local content = vim.api.nvim_buf_get_lines(M.popup_buf, 0, -1, true)
  local extmarks = vim.api.nvim_buf_get_extmarks(M.popup_buf, M.ns_id, 0, -1, {})
  -- build one-indexed row to extmark_id list map
  local row_to_extmarks = {}
  for _, em in ipairs(extmarks) do
    local id, row, col = em[1], em[2], em[3]
    row = row + 1
    -- extmarks were added in column 1, but they move when editing
    if 0 < col and col < 5 then
      if row_to_extmarks[row] then
        notify('Invalid UI state (duplicate marks): changes discarded', 'err')
        return
      end
      row_to_extmarks[row] = id
    end
  end

  -- Determine the target state
  local target_state = {}
  for row = 1, #content do
    local line_str = content[row]
    -- remove leading and trailing spaces
    line_str = line_str:match('^%s*(.-)%s*$')
    if line_str ~= '' then
      local parsed_num_str, parsed_name = line_str:match('^(%d+)%s+(.+)')
      if not parsed_name then parsed_name = line_str:match('^%s*(.+)') end
      if not parsed_name then
        notify('Invalid UI state (bad line): changes discarded', 'err')
        return
      end
      -- leading number optional, use line number if absent
      local num_tar_idx = parsed_num_str and tonumber(parsed_num_str) or row

      local new_mark = {}
      local ext_id = row_to_extmarks[row]
      -- the name and extmark align
      if
        ext_id
        and M.ui_extmarks[ext_id]
        and parsed_name == vim.fn.fnamemodify(M.ui_extmarks[ext_id].argname, ':.')
      then
        if _debug_ui then notify('Matching Name and extmark', 'debug') end
        local mark = M.ui_extmarks[ext_id]
        if mark.markindex == num_tar_idx then num_tar_idx = row end
        new_mark = {
          new_mark_idx = num_tar_idx,
          argname = mark.argname,
          last_line = mark.last_line,
          loaded = mark.loaded,
        }
      else
        -- have a mark but the buffer changes
        if ext_id and M.ui_extmarks[ext_id] then
          if _debug_ui then notify('Have extmark and new name', 'debug') end
          local mark = M.ui_extmarks[ext_id]
          if mark.markindex == num_tar_idx then num_tar_idx = row end
          local new_argname = vim.fn.fnamemodify(parsed_name, ':p')
          if not vim.uv.fs_stat(new_argname) then
            notify('Invalid UI state (change to missing): discarding changes', 'err')
            return
          end
          new_mark = {
            new_mark_idx = num_tar_idx,
            argname = new_argname,
          }
        -- no mark on the line (could also have been lost)
        else
          if _debug_ui then notify('No extmark on line', 'debug') end
          local new_argname = vim.fn.fnamemodify(parsed_name, ':p')
          if not vim.uv.fs_stat(new_argname) then
            notify('Invalid UI state (create missing): discarding changes', 'err')
            return
          end
          new_mark = {
            new_mark_idx = row,
            argname = new_argname,
          }
        end
      end
      table.insert(target_state, new_mark)
    end
  end

  -- Check for row collisions and name duplicates
  local indices = {}
  local names = {}
  for _, value in ipairs(target_state) do
    local idx = value.new_mark_idx
    local name = value.argname
    if indices[idx] then
      notify('Invalid UI state (index duplicate): discarding changes', 'err')
      return
    end
    indices[idx] = true
    if names[name] then
      notify('Invalid UI state (buffer duplicate): discarding changes', 'err')
      return
    end
    names[name] = true
  end

  -- Update the state
  local new_marks = {}
  for _, value in ipairs(target_state) do
    local entry = {
      -- defaulting to true here can lose data if the extmark is lost due to
      -- edits, but we don't want to jump to line 1 in the other cases
      loaded = value.loaded or true,
      markindex = value.new_mark_idx,
      argname = value.argname,
      last_line = value.last_line or 1,
      argindex = -1, -- init occurs during apply_state()
    }
    new_marks[entry.markindex] = entry
  end
  M.state.marks = new_marks
  apply_state()
  if M.config.enable_autosave then M.func.save_state() end
end

--
-- Interface Functions
--

--- Save plugin state to disk
function M.func.save_state()
  M.init()
  -- saved based on cwd, then keep it, even if cwd changes
  local savefilename = M.state.savefilename or get_save_file_name()
  if not savefilename then return end

  if vim.tbl_isempty(M.state.marks) then
    if not vim.uv.fs_stat(savefilename) then return end
  end

  local dir = vim.fn.fnamemodify(savefilename, ':h')
  if vim.fn.isdirectory(dir) == 0 then
    if vim.fn.mkdir(dir, 'p') == 0 then
      notify(string.format('Cannot save state (mkdir failed for: %s)', dir), 'err')
      return
    end
  end

  local file, err = io.open(savefilename, 'w')
  if not file then
    notify(string.format('Cannot save state (file open failed: %s)', err), 'err')
    return
  end

  local export_state = {
    current = M.state.current,
    marks = {},
  }
  for _, mark in pairs(M.state.marks) do
    table.insert(export_state.marks, {
      argname = mark.argname,
      markindex = mark.markindex,
      last_line = mark.last_line,
    })
  end
  local ok, encoded_state = pcall(vim.json.encode, export_state)
  if not ok then
    file:close()
    notify('Failed to encode state: ' .. tostring(encoded_state), 'err')
    return
  end

  file:write(encoded_state)
  file:flush()
  file:close()

  if not M.config.enable_autosave then notify('Saved state', 'info') end
end

--- Load plugin state from disk
--- extends current state with the state, no change if no save available
function M.func.load_state()
  M.init()
  -- load based on cwd, then keep it, even if cwd changes
  local savefilename = M.state.savefilename or get_save_file_name()
  if not savefilename then return end

  local file = io.open(savefilename, 'r')
  if not file then
    if not M.config.enable_autosave then notify('No saved state found', 'info') end
    return
  end

  local content = file:read('*a')
  file:close()
  local ok, readstate = pcall(vim.json.decode, content)
  if not ok then
    notify('Loading state error (parse error): aborting', 'err')
    return
  end

  if type(readstate.marks) == 'table' and type(readstate.current) == 'number' then
    local load_state = {}
    for _, value in pairs(readstate.marks) do
      if
        type(value) == 'table'
        and type(value.markindex) == 'number'
        and type(value.last_line) == 'number'
        and type(value.argname) == 'string'
      then
        local entry = {
          loaded = false, -- on fresh load want to use last_line
          markindex = value.markindex,
          argname = value.argname,
          last_line = value.last_line,
          argindex = -1, -- init occurs during apply_state()
        }
        if load_state[value.markindex] then
          notify('Loading state error (duplicate marks): aborting', 'err')
          return
        end
        load_state[value.markindex] = entry
      else
        notify('Found invalid mark in saved state', 'warn')
      end
    end
    M.state.current = readstate.current
    M.state.marks = load_state
    apply_state()
    if not M.config.enable_autosave then notify('Loaded state', 'info') end
  else
    notify('Loading state error (invalid): aborting', 'err')
  end
end

--- Add or update a mark at the given index (or append if no index given)
function M.func.mark(index)
  M.init()
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == '' then
    notify('Cannot mark an unnamed buffer', 'warn')
    return
  end

  -- internally always use absolute paths
  local argname = vim.fn.fnamemodify(current_file, ':p')
  -- prevent duplicate entries, but allow updates
  for k, v in pairs(M.state.marks) do
    if v.argname == argname then
      if index == nil or index == k then
        -- same or no index, update the state for the mark
        index = k
        break
      else
        notify(string.format('Buffer already marked (index: %d)', k), 'info')
        return
      end
    end
  end

  if not index then
    if M.config.append_to_end then
      index = get_max_mark_index(M.state.marks) + 1
    else
      -- use first available slot
      index = 1
      while M.state.marks[index] ~= nil do
        index = index + 1
      end
    end
  end

  M.state.marks[index] = {
    argname = argname,
    markindex = index,
    last_line = vim.fn.line('.'),
    loaded = true,
    argindex = -1, -- calculated by apply_state
  }
  M.state.current = index
  apply_state()
  if M.config.enable_autosave then M.func.save_state() end
  if _debug then notify('Marked at ' .. index, 'debug') end
end

--- Remove a mark at the given index (or current file if no index)
function M.func.unmark(index)
  M.init()
  if not index then
    -- Try to find the current file in marks to unmark it
    local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
    for k, v in pairs(M.state.marks) do
      if v and v.argname == current_file then
        index = k
        break
      end
    end
  end

  if index then
    M.state.marks[index] = nil
    apply_state()
    if M.config.enable_autosave then M.func.save_state() end
    if _debug then notify('Removed mark ' .. index, 'debug') end
  else
    notify('No mark to remove for this buffer', 'info')
  end
end

--- Jump to the mark given by the index argument
---@param index integer
function M.func.select(index)
  M.init()
  local midx = nil
  if M.state.marks[index] and M.state.marks[index].markindex == index then
    midx = index
  end
  local mark = midx and M.state.marks[midx] or nil
  if not mark then
    notify('No mark for index ' .. tostring(index), 'info')
    return
  end

  local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
  -- update cursor position of the buffer we are currently leaving (if marked)
  for _, v in pairs(M.state.marks) do
    if v.argname == current_file then
      v.last_line = vim.fn.line('.')
      break
    end
  end
  -- do nothing if the current buffer is the target
  if mark.argname == current_file then return end

  local success, err = pcall(function()
    vim.cmd(mark.argindex .. 'argument')
  end)
  if success then
    M.state.current = index
    if M.state.marks[index].loaded == false then
      local bufnr = vim.fn.bufnr()
      vim.fn.setpos('.', { bufnr, mark.last_line, 1, 1 })
      M.state.marks[index].loaded = true
    else
      M.state.marks[index].last_line = vim.fn.line('.')
    end
  else
    notify('Failed to jump (' .. tostring(err) .. ')', 'err')
  end
end

--- Jump to the next available mark (wraps around)
function M.func.select_next()
  M.init()
  if not M.state.current then return end
  local next_idx = M.state.current + 1
  local max_idx = get_max_mark_index(M.state.marks)
  -- Search forward
  while next_idx <= max_idx do
    if M.state.marks[next_idx] then
      M.func.select(next_idx)
      return
    end
    next_idx = next_idx + 1
  end
  -- Wrap around
  for i = 1, M.state.current - 1 do
    if M.state.marks[i] then
      M.func.select(i)
      return
    end
  end
end

--- Jump to the previous available mark (wraps around)
function M.func.select_prev()
  M.init()
  if not M.state.current then return end
  local prev_idx = M.state.current - 1
  -- Search backward
  while prev_idx >= 1 do
    if M.state.marks[prev_idx] then
      M.func.select(prev_idx)
      return
    end
    prev_idx = prev_idx - 1
  end
  -- Wrap around
  local max_idx = get_max_mark_index(M.state.marks)
  while max_idx > M.state.current do
    if M.state.marks[max_idx] then
      M.func.select(max_idx)
      return
    end
    max_idx = max_idx - 1
  end
end

--- Select mark based on current cursor line, should only be bound in the UI buffer
function M.func.select_via_ui()
  M.init()
  if M.popup_win == nil then return end
  local target = vim.fn.line('.')
  M.func.close_ui()
  M.func.select(target)
end

--- Open the UI window
function M.func.open_ui()
  M.init()
  if M.popup_win and vim.api.nvim_win_is_valid(M.popup_win) then return end
  -- create the popup buffer
  local popup_buf = vim.api.nvim_create_buf(false, true)
  M.popup_buf = popup_buf
  vim.bo[popup_buf].bufhidden = 'wipe'
  vim.bo[popup_buf].buftype = 'nofile'
  vim.bo[popup_buf].filetype = 'argmada-ui-popup'
  -- create the popup window and open the buffer in it
  local max_idx = get_max_mark_index(M.state.marks)
  local height = max_idx + M.config.ui_after_padding
  local width = M.config.ui_width
  local popup_win = vim.api.nvim_open_win(popup_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = math.ceil((vim.o.lines - height) / 2),
    col = math.ceil((vim.o.columns - width) / 2),
    title = ' Argmada ',
    title_pos = 'center',
    style = 'minimal',
  })
  M.popup_win = popup_win
  vim.wo[popup_win].cursorline = true
  vim.wo[popup_win].number = false
  vim.wo[popup_win].wrap = false

  -- determine what the current mark is for highlight and cursor position
  local cursor_pos = M.state.current or 1
  -- set the content of the popup buffer
  local lines = {}
  for i = 1, height do
    local v = M.state.marks[i]
    if v then
      table.insert(lines, print_entry(v))
    else
      table.insert(lines, ' ') -- Empty line for empty slot
    end
  end
  vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, lines)

  -- set ext_marks to help track changes
  M.ui_extmarks = {}
  for i = 1, max_idx do
    local v = M.state.marks[i]
    if v then
      local idx_len = string.len(tostring(v.markindex))
      local line_len = string.len(lines[i])
      local pos_idx_end = { i - 1, idx_len + 1 }
      local pos_end = { i - 1, line_len }
      vim.hl.range(popup_buf, M.hl_ns_id, 'ArgmadaIndex', { i - 1, 0 }, pos_idx_end)
      if i ~= cursor_pos then
        vim.hl.range(popup_buf, M.hl_ns_id, 'ArgmadaPath', pos_idx_end, pos_end)
      else
        vim.hl.range(popup_buf, M.hl_ns_id, 'ArgmadaPathCur', pos_idx_end, pos_end)
      end

      local extmark_id =
        vim.api.nvim_buf_set_extmark(popup_buf, M.ns_id, i - 1, 1, {})
      M.ui_extmarks[extmark_id] = {
        argname = v.argname,
        loaded = v.loaded,
        last_line = v.last_line,
        markindex = v.markindex,
        -- argindex is unnecessary, but I don't want to define a type just for this
        argindex = -1,
      }
    end
  end
  -- place cursor on last jump that was made
  vim.cmd.normal({ cursor_pos .. 'G', bang = true })

  -- auto close the window if buffer or window changes
  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
    group = M.augroup,
    buffer = popup_buf,
    callback = function()
      if M.popup_buf ~= nil then
        sync_ui()
        M.func.close_ui()
      end
    end,
  })
end

--- Close the UI, state sync is handled by autocmd (set in open_ui)
function M.func.close_ui()
  M.init()
  if M.popup_win == nil then return end
  if M.popup_win and vim.api.nvim_win_is_valid(M.popup_win) then
    -- buffer is set to 'wipe' so this deletes the ext_marks as well
    vim.api.nvim_win_close(M.popup_win, true)
  end
  M.popup_win = nil
  M.popup_buf = nil
  M.ui_extmarks = {}
end

--- Toggle the UI window
function M.func.toggle_ui()
  M.init()
  if M.popup_buf ~= nil and M.popup_win ~= nil then
    M.func.close_ui()
  else
    M.func.open_ui()
  end
end

--- Init the plugin (config merge and autoload + some misc.)
function M.init()
  if M.plugin_loaded == true then return end
  M.plugin_loaded = true

  local user_config = vim.g.argmada_config or {}

  M.config = vim.tbl_deep_extend('force', default_config, user_config)

  -- autosave
  if M.config.enable_autosave then
    -- load
    M.func.load_state()
    -- setup save before exit
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = M.augroup,
      callback = M.func.save_state,
    })
  end

  -- trigger garbage collection (settings checked internally)
  vim.schedule(function()
    garbage_collect()
  end)

  -- setup buffer highlights
  local base_hl = vim.api.nvim_get_hl(0, { name = 'Normal' })
  vim.api.nvim_set_hl(0, 'ArgmadaPath', { link = 'Normal', default = true })
  vim.api.nvim_set_hl(
    0,
    'ArgmadaIndex',
    { fg = base_hl.fg, italic = true, default = true }
  )
  vim.api.nvim_set_hl(
    0,
    'ArgmadaPathCur',
    { fg = base_hl.fg, bold = true, default = true }
  )
end

return M
