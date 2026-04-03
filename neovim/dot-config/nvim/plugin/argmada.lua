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
---@field cleanup_days_limit integer
---@field keep_default_binds boolean
---@field keymaps table

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
---@field setup function
---@field config ArgmadaConfig
---@field func ArgmadaFunctions
---@field state ArgmadaState
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
  append_to_end = false,
  keep_default_binds = true,
  cleanup_days_limit = 30,
  keymaps = {
    normal = {
      ['<C-s>'] = { 'mark', {}, { desc = 'Argmada: Append new Mark' } },
      ['<C-h>'] = { 'toggle_ui', {}, { desc = 'Argmada: Toggle UI' } },
      ['<leader>am'] = { 'mark', { 1 }, { desc = 'Argmada: Mark 1' } },
      ['<leader>an'] = { 'mark', { 2 }, { desc = 'Argmada: Mark 2' } },
      ['<leader>ab'] = { 'mark', { 3 }, { desc = 'Argmada: Mark 3' } },
      ['<leader>av'] = { 'mark', { 4 }, { desc = 'Argmada: Mark 4' } },
      ['<leader>m'] = { 'select', { 1 }, { desc = 'Argmada: Go to 1' } },
      ['<leader>n'] = { 'select', { 2 }, { desc = 'Argmada: Go to 2' } },
      ['<leader>b'] = { 'select', { 3 }, { desc = 'Argmada: Go to 3' } },
      ['<leader>v'] = { 'select', { 4 }, { desc = 'Argmada: Go to 4' } },
      ['[h'] = { 'prev', {}, { desc = 'Argmada: previous Mark' } },
      [']h'] = { 'next', {}, { desc = 'Argmada: next Mark' } },
      ['<leader>hc'] = { 'unmark', {}, { desc = 'Argmada: Remove Mark' } },
    },
    visual = {},
    insert = {},
    -- keybinds added to the UI buffer (normal mode)
    ui = {
      ['<CR>'] = { 'select_ui' },
      ['q'] = { 'close_ui' },
      ['<ESC>'] = { 'close_ui' },
    },
  },
}

---@type ArgmadaPlugin
local M = {
  setup = nil, ---@diagnostic disable-line:assign-type-mismatch
  func = {}, ---@diagnostic disable-line:missing-fields
  config = default_config,
  state = {
    savefilename = nil,
    current = nil,
    marks = {},
  },
  plugin_loaded = false,
  augroup = vim.api.nvim_create_augroup('Argmada.au', { clear = true }),
  popup_win = nil,
  popup_buf = nil,
  state_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'argmada'),
  ns_id = vim.api.nvim_create_namespace('argmada_ui'),
  ui_extmarks = {},
}

--- config interface map that gives stable names to functions
--- also allows setup to change things dynamically
--- definition after the functions have been defined
local keybind_map = {}

--
-- Internal Functions
--

--- enable debug messages
local _debug = false

local function notify(msg, level)
  vim.notify(msg, level, { title = 'Argmada' })
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
  for k in pairs(marks) do
    if k > max_idx then max_idx = k end
  end
  return max_idx
end

--- determine the save file name (based on cwd)
---@return string?
local function get_save_file_name()
  local basedir = vim.uv.cwd()
  if type(basedir) ~= 'string' then
    notify('Cannot determine save file name (uv.cwd() failed)', vim.log.levels.ERROR)
    return nil
  end
  local strip_home = vim.fn.fnamemodify(basedir, ':~')
  local basename = 'f' .. strip_home:gsub('[\\/:]', '-')
  local path = vim.fs.joinpath(M.state_dir, basename .. '-state.json')
  return path
end

--- Clean up old state files that haven't been modified in X days
--- Uses a tag file to do the check at most once every 24h
local function garbage_collect()
  -- special case X=0 means disabled
  if M.config.cleanup_days_limit == 0 then return end
  local tag_file = vim.fs.joinpath(M.state_dir, 'gc_tag')
  if vim.fn.isdirectory(M.state_dir) == 0 then vim.fn.mkdir(M.state_dir, 'p') end

  -- wait at least 24h before checking again
  local tag_stat = vim.uv.fs_stat(tag_file)
  local now = os.time()
  if tag_stat and (now - tag_stat.mtime.sec) < 86400 then return end

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
        if _debug then notify('GC removed ' .. name, vim.log.levels.DEBUG) end
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
  if _debug then notify('apply_state() called', vim.log.levels.DEBUG) end

  -- Extract into a list and sort by markindex to handle gaps
  local sorted_marks = {}
  for k, v in pairs(M.state.marks) do
    table.insert(sorted_marks, { markindex = k, data = v })
  end
  table.sort(sorted_marks, function(a, b)
    return a.markindex < b.markindex
  end)

  -- clear current arglist and rebuild it, sync "physical" state back into the argindex
  vim.cmd('%argdelete')
  local physical_index = 1
  for _, entry in ipairs(sorted_marks) do
    local safe_name = vim.fn.fnameescape(entry.data.argname)
    vim.cmd('$argadd ' .. safe_name)
    entry.data.argindex = physical_index
    physical_index = physical_index + 1
  end
end

--- Sync the UI buffer state to plugin state using extmarks
local function sync_ui()
  if _debug then notify('Called Sync()', vim.log.levels.DEBUG) end
  if not (M.popup_win and vim.api.nvim_win_is_valid(M.popup_win)) then return end

  -- 1 Collect the state info from the UI buffer
  local content = vim.api.nvim_buf_get_lines(M.popup_buf, 0, -1, true)
  local extmarks = vim.api.nvim_buf_get_extmarks(M.popup_buf, M.ns_id, 0, -1, {})
  -- build zero-indexed row to extmark_id list map
  local row_to_extmarks = {}
  for _, em in ipairs(extmarks) do
    local id, row = em[1], em[2]
    row_to_extmarks[row] = row_to_extmarks[row] or {}
    table.insert(row_to_extmarks[row], id)
  end
  -- collect the state
  local parsed_lines = {}
  local claimed_indices = {}
  for row = 0, #content - 1 do
    local line_str = content[row + 1]
    if not line_str:match('^%s*$') then
      local parsed_num_str, parsed_name = line_str:match('^(%d+)%s+(.+)')
      if not parsed_name then parsed_name = line_str:match('^%s*(.+)') end
      if not parsed_name then
        notify(
          'Invalid UI state (bad parsing): changes discarded',
          vim.log.levels.ERROR
        )
        return
      end
      -- leading number optional, use line number if absent
      local parsed_num = parsed_num_str and tonumber(parsed_num_str) or (row + 1)
      local extmark_ids = row_to_extmarks[row] or {}
      local extmark_id = nil

      if #extmark_ids == 1 then
        extmark_id = extmark_ids[1]
      elseif #extmark_ids > 1 then
        -- If multiple (from a deleted line), find the best match
        for _, id in ipairs(extmark_ids) do
          local mark = M.ui_extmarks[id]
          if mark and parsed_name == vim.fn.fnamemodify(mark.argname, ':.') then
            extmark_id = id
            break
          end
        end
        -- Fallback if no exact match (e.g. user deleted a line AND edited the path)
        if not extmark_id then extmark_id = extmark_ids[1] end
      end
      local mark_data = extmark_id and M.ui_extmarks[extmark_id] or nil
      local orig_line = mark_data and mark_data.markindex or nil
      table.insert(parsed_lines, {
        new_idx = row + 1,
        orig_idx = orig_line,
        parsed_idx = parsed_num,
        parsed_name = parsed_name,
        orig_mark = mark_data,
      })
      claimed_indices[row + 1] = true
    end
  end

  -- 2 Apply the "leading integer" rule for unmoved lines
  for _, entry in ipairs(parsed_lines) do
    local orig_mark_idx = entry.orig_mark and entry.orig_mark.markindex or nil

    if entry.parsed_idx ~= entry.new_idx and entry.parsed_idx ~= orig_mark_idx then
      if not claimed_indices[entry.parsed_idx] then
        claimed_indices[entry.new_idx] = false
        entry.new_idx = entry.parsed_idx
        claimed_indices[entry.parsed_idx] = true
      end
    end
  end

  -- 3 Update state
  local new_marks = {}
  for _, entry in ipairs(parsed_lines) do
    local mark = nil
    if entry.orig_mark then
      mark = {
        argname = entry.orig_mark.argname,
        loaded = entry.orig_mark.loaded,
        last_line = entry.orig_mark.last_line,
        argindex = -1,
      }
      local current_rel = vim.fn.fnamemodify(mark.argname, ':.')
      if entry.parsed_name ~= current_rel then
        local new_abs = vim.fn.fnamemodify(entry.parsed_name, ':p')
        if vim.uv.fs_stat(new_abs) then
          mark.argname = new_abs
        else
          notify(
            'Invalid UI state (change non-existant): dicarding changes',
            vim.log.levels.ERROR
          )
          return
        end
      end
    else
      local new_abs = vim.fn.fnamemodify(entry.parsed_name, ':p')
      if vim.uv.fs_stat(new_abs) then
        mark = {
          argname = new_abs,
          loaded = true,
          last_line = 1,
          argindex = -1,
        }
      else
        notify(
          'Invalid UI state (create non-existant): dicarding changes',
          vim.log.levels.ERROR
        )
        return
      end
    end

    if mark then
      mark.markindex = entry.new_idx
      new_marks[entry.new_idx] = mark
    end
  end

  M.state.marks = new_marks
  apply_state()
  if M.config.enable_autosave then M.func.save_state() end
end

--
-- Functions
--

--- Save plugin state to disk
function M.func.save_state()
  local savefilename = M.state.savefilename or get_save_file_name()
  if not savefilename then return end

  if vim.tbl_isempty(M.state.marks) then
    if not vim.uv.fs_stat(savefilename) then return end
  end

  local dir = vim.fn.fnamemodify(savefilename, ':h')
  if vim.fn.isdirectory(dir) == 0 then
    if vim.fn.mkdir(dir, 'p') == 0 then
      notify(
        string.format('Cannot save state (mkdir failed for: %s)', dir),
        vim.log.levels.ERROR
      )
      return
    end
  end

  local file, err = io.open(savefilename, 'w')
  if not file then
    notify(
      string.format('Cannot save state (file open failed: %s)', err),
      vim.log.levels.ERROR
    )
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
    notify(
      'Failed to encode state: ' .. tostring(encoded_state),
      vim.log.levels.ERROR
    )
    return
  end

  file:write(encoded_state)
  file:flush()
  file:close()

  if not M.config.enable_autosave then notify('Saved state', vim.log.levels.INFO) end
end

--- Load plugin state from disk
--- extends current state with the state, no change if no save available
function M.func.load_state()
  -- load it based on cwd, then keep it, even if cwd changes
  local savefilename = M.state.savefilename or get_save_file_name()
  if not savefilename then return end

  local file = io.open(savefilename, 'r')
  if not file then
    if not M.config.enable_autosave then
      notify('No saved state found', vim.log.levels.INFO)
    end
    return
  end

  local content = file:read('*a')
  file:close()
  local ok, readstate = pcall(vim.json.decode, content)
  if not ok then
    notify('Failed to parse saved state', vim.log.levels.ERROR)
    return
  end

  M.state.current = readstate.current
  for _, value in ipairs(readstate.marks) do
    if value ~= vim.NIL then
      local entry = {
        loaded = false, -- on fresh load want to use last_line
        markindex = value.markindex,
        argname = value.argname,
        last_line = value.last_line,
        argindex = -1, -- init occurs during apply_state()
      }
      M.state.marks[value.markindex] = entry
    end
  end
  apply_state()
  if not M.config.enable_autosave then
    notify('Loaded state', vim.log.levels.INFO)
  end
end

--- Add or update a mark at the given index (or append if no index given)
function M.func.mark(index)
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == '' then
    notify('Cannot mark an unnamed buffer', vim.log.levels.WARN)
    return
  end

  -- Use path relative to cwd for cleaner UI and portability
  local argname = vim.fn.fnamemodify(current_file, ':p')

  -- prevent duplicate entries, but allow updates
  for k, v in pairs(M.state.marks) do
    if v.argname == argname then
      if index == nil or index == k then
        -- same or no index, update the state for the mark
        index = k
        break -- continue to update
      else
        -- Do not allow duplicates
        notify(
          string.format('Buffer already marked (index: %d)', k),
          vim.log.levels.INFO
        )
        return -- exit
      end
    end
  end

  if not index then
    if M.config.append_to_end then
      -- append at the end of the list, skipping over gaps
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

  apply_state()
  if M.config.enable_autosave then M.func.save_state() end
  if _debug then notify('Marked at ' .. index, vim.log.levels.DEBUG) end
end

--- Remove a mark at the given index (or current file if no index)
function M.func.unmark(index)
  if not index then
    -- Try to find the current file in marks to unmark it
    local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
    for k, v in pairs(M.state.marks) do
      if v.argname == current_file then
        index = k
        break
      end
    end
  end

  if index and M.state.marks[index] then
    M.state.marks[index] = nil
    apply_state()
    if M.config.enable_autosave then M.func.save_state() end
    if _debug then notify('Removed mark ' .. index, vim.log.levels.DEBUG) end
  else
    notify('No mark to remove for this buffer', vim.log.levels.INFO)
  end
end

--- Jump to the mark given by the index argument
---@param index integer
function M.func.select(index)
  local mark = M.state.marks[index]
  if not mark then
    notify('No mark for index ' .. tostring(index), vim.log.levels.INFO)
    return
  end

  -- update cursor position of the buffer we are currently leaving (if marked)
  local current_file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
  for _, v in pairs(M.state.marks) do
    if v.argname == current_file then
      v.last_line = vim.fn.line('.')
      break
    end
  end

  M.state.current = index
  local success, err = pcall(function()
    vim.cmd(mark.argindex .. 'argument')
  end)

  if success then
    if M.state.marks[index].loaded == false then
      local bufnr = vim.fn.bufnr()
      vim.fn.setpos('.', { bufnr, mark.last_line, 1, 1 })
      M.state.marks[index].loaded = true
    else
      M.state.marks[index].last_line = vim.fn.line('.')
    end
  else
    notify('Failed to jump - ' .. tostring(err), vim.log.levels.ERROR)
  end
end

--- Jump to the next available mark (wraps around)
function M.func.select_next()
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
  -- Wrap around, first find max index
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
  local target = vim.fn.line('.')
  M.func.close_ui()
  M.func.select(target)
end

--- Open the UI window
function M.func.open_ui()
  -- if already open nothing to be done
  if M.popup_win and vim.api.nvim_win_is_valid(M.popup_win) then return end
  -- create the popup buffer
  local popup_buf = vim.api.nvim_create_buf(false, true)
  M.popup_buf = popup_buf
  vim.bo[popup_buf].bufhidden = 'wipe'
  vim.bo[popup_buf].filetype = 'argmada-popup'
  vim.bo[popup_buf].buftype = 'nofile'
  vim.bo[popup_buf].bufhidden = 'wipe'
  -- create the popup window and open the buffer in it
  local max_idx = get_max_mark_index(M.state.marks)
  local height = max_idx + M.config.ui_after_padding
  local width = 80
  local row = math.ceil((vim.o.lines - height) / 2)
  local col = math.ceil((vim.o.columns - width) / 2)
  local popup_win = vim.api.nvim_open_win(popup_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    title = ' Argmada ',
    title_pos = 'center',
    style = 'minimal',
  })
  M.popup_win = popup_win
  vim.wo[popup_win].cursorline = true
  vim.wo[popup_win].number = false
  vim.wo[popup_win].wrap = false
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
  -- set ext_marks to track changes
  M.ui_extmarks = {}
  for i = 1, max_idx do
    local v = M.state.marks[i]
    if v then
      local extmark_id =
        vim.api.nvim_buf_set_extmark(popup_buf, M.ns_id, i - 1, 0, {})
      M.ui_extmarks[extmark_id] = {
        argname = v.argname,
        loaded = v.loaded,
        last_line = v.last_line,
        markindex = v.markindex,
        argindex = v.argindex,
      }
    end
  end
  -- place cursor on last jump
  local cursor_pos = M.state.current or 1
  -- vim.cmd('norm! ' .. cursor_pos .. 'G')
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
  -- set keymaps
  for key, mapping in pairs(M.config.keymaps.ui or {}) do
    if mapping then
      local action = keybind_map[mapping[1]]
      local args = mapping[2] or {}
      vim.keymap.set('n', key, function()
        action(unpack(args))
      end, { buffer = popup_buf })
    end
  end
end

--- Close the UI, state sync is handled by autocmd (set in open_ui)
function M.func.close_ui()
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
  if M.popup_buf ~= nil and M.popup_win ~= nil then
    M.func.close_ui()
  else
    M.func.open_ui()
  end
end

--
-- Setup and keybind_map
--

keybind_map = {
  ['mark'] = M.func.mark,
  ['unmark'] = M.func.unmark,
  ['toggle_ui'] = M.func.toggle_ui,
  ['open_ui'] = M.func.open_ui,
  ['close_ui'] = M.func.close_ui,
  ['save'] = M.func.save_state,
  ['load'] = M.func.load_state,
  ['select'] = M.func.select,
  ['next'] = M.func.select_next,
  ['prev'] = M.func.select_prev,
  ['select_ui'] = M.func.select_via_ui,
}

--- Init the plugin
--- Override default config with opts argument
---@param config table?
function M.setup(config)
  if M.plugin_loaded then return end
  M.plugin_loaded = true

  if config and config.keep_default_binds == false then
    default_config.keymaps = { normal = {}, visual = {}, insert = {}, ui = {} }
  end

  M.config = vim.tbl_deep_extend('force', default_config, config or {})

  if M.config.enable_autosave then
    keybind_map['save'] = function()
      notify('Save disabled', vim.log.levels.INFO)
    end
    keybind_map['load'] = function()
      notify('Load disabled', vim.log.levels.INFO)
    end

    -- handle lazy loading
    if vim.v.vim_did_enter == 1 then
      M.func.load_state()
    else
      vim.api.nvim_create_autocmd('VimEnter', {
        group = M.augroup,
        callback = M.func.load_state,
      })
    end
    -- save before exit
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = M.augroup,
      callback = M.func.save_state,
    })
  end

  for key, mapping in pairs(M.config.keymaps.normal or {}) do
    if mapping then
      local action = keybind_map[mapping[1]]
      local args = mapping[2] or {}
      local opts = mapping[3] or {}
      vim.keymap.set('n', key, function()
        action(unpack(args))
      end, opts)
    end
  end

  for key, mapping in pairs(M.config.keymaps.visual or {}) do
    if mapping then
      local action = keybind_map[mapping[1]]
      local args = mapping[2] or {}
      local opts = mapping[3] or {}
      vim.keymap.set('v', key, function()
        action(unpack(args))
      end, opts)
    end
  end

  for key, mapping in pairs(M.config.keymaps.insert or {}) do
    if mapping then
      local action = keybind_map[mapping[1]]
      local args = mapping[2] or {}
      local opts = mapping[3] or {}
      vim.keymap.set('i', key, function()
        action(unpack(args))
      end, opts)
    end
  end

  vim.schedule(function()
    garbage_collect()
  end)
end

-- return M

vim.schedule(function()
  M.setup()
end)
