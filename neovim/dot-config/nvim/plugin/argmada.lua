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
---@field print_entry function
---@field get_save_file_name function
---@field garbage_collect function
---@field apply_state function
---@field sync_ui function
---@field select_via_ui function
---@field save_state function
---@field load_state function
---@field mark function
---@field unmark function
---@field select function
---@field select_next function
---@field select_prev function
---@field open_ui function
---@field close_ui function
---@field toggle_ui function

---@class ArgmadaPlugin
---@field setup function
---@field config ArgmadaConfig
---@field func ArgmadaFunctions
---@field state ArgmadaState
---@field plugin_loaded boolean
---@field augroup integer?
---@field popup_win integer?
---@field popup_buf integer?
---@field state_dir string

---@type ArgmadaConfig
local default_config = {
  enable_autosave = true,
  ui_after_padding = 3,
  append_to_end = false,
  keep_default_binds = true,
  cleanup_days_limit = 30,
  keymaps = {
    normal = {
      { '<C-s>', 'mark', {}, { desc = 'Argmada: Append new Mark' } },
      { '<C-h>', 'toggle_ui', {}, { desc = 'Argmada: Toggle UI' } },
      { '<leader>am', 'mark', { 1 }, { desc = 'Argmada: Mark 1' } },
      { '<leader>an', 'mark', { 2 }, { desc = 'Argmada: Mark 2' } },
      { '<leader>ab', 'mark', { 3 }, { desc = 'Argmada: Mark 3' } },
      { '<leader>av', 'mark', { 4 }, { desc = 'Argmada: Mark 4' } },
      { '<leader>m', 'select', { 1 }, { desc = 'Argmada: Go to 1' } },
      { '<leader>n', 'select', { 2 }, { desc = 'Argmada: Go to 2' } },
      { '<leader>b', 'select', { 3 }, { desc = 'Argmada: Go to 3' } },
      { '<leader>v', 'select', { 4 }, { desc = 'Argmada: Go to 4' } },
      { '[h', 'prev', {}, { desc = 'Argmada: previous Mark' } },
      { ']h', 'next', {}, { desc = 'Argmada: next Mark' } },
      { '<leader>hc', 'unmark', {}, { desc = 'Argmada: Remove Mark' } },
    },
    visual = {},
    insert = {},
    -- keybinds added to the UI buffer (normal mode)
    ui = {
      { '<CR>', 'select_ui' },
      { 'q', 'close_ui' },
      { '<ESC>', 'close_ui' },
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
  augroup = nil,
  popup_win = nil,
  popup_buf = nil,
  state_dir = vim.fn.stdpath('data') .. '/argmada',
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

--- Get the pretty string of a MarkElement
---@param mark ArgMarkElement
---@return string
function M.func.print_entry(mark)
  local relative_name = vim.fn.fnamemodify(mark.argname, ':.')
  return string.format('%i %s', mark.markindex, relative_name)
end

--- determine the save file name (based on cwd)
---@return string?
function M.func.get_save_file_name()
  local uv = vim.uv or vim.loop
  local basedir = uv.cwd()
  if type(basedir) ~= 'string' then
    vim.notify(
      'Cannot determine save file name (uv.cwd() failed)',
      vim.log.levels.ERROR,
      { title = 'Argmada' }
    )
    return nil
  end
  local strip_home = vim.fn.fnamemodify(basedir, ':~')
  local basename = strip_home:gsub('[\\/:]', '-')
  return M.state_dir .. '/' .. basename .. '-state.json'
end

--- Clean up old state files that haven't been modified in X days
--- Uses a tag file to do the check at most once every 24h
function M.func.garbage_collect()
  -- special case X=0 means disabled
  if M.config.cleanup_days_limit == 0 then return end
  local tag_file = M.state_dir .. '/gc_tag'
  local uv = vim.uv or vim.loop
  if vim.fn.isdirectory(M.state_dir) == 0 then vim.fn.mkdir(M.state_dir, 'p') end

  -- wait at least 24h before checking again
  local tag_stat = uv.fs_stat(tag_file)
  local now = os.time()
  if tag_stat and (now - tag_stat.mtime.sec) < 86400 then return end

  local handle = uv.fs_scandir(M.state_dir)
  if not handle then return end
  local limit_sec = M.config.cleanup_days_limit * 86400
  while true do
    local name, _ = uv.fs_scandir_next(handle)
    if not name then break end
    if name:match('%-state.json$') then
      local path = M.state_dir .. '/' .. name
      local stat = uv.fs_stat(path)
      if stat and (now - stat.mtime.sec) > limit_sec then
        os.remove(path)
        if _debug then
          vim.notify('Argmada: GC removed ' .. name, vim.log.levels.DEBUG)
        end
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
function M.func.apply_state()
  if _debug then
    vim.notify('apply_state() called', vim.log.levels.DEBUG, { title = 'Argmada' })
  end

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

--- Sync the UI buffer state to plugin state
--- only updates if the UI buffer is valid, otherwise changes are discarded
function M.func.sync_ui()
  if _debug then vim.notify('Argmada: Called Sync()', vim.log.levels.DEBUG) end
  if M.popup_win and vim.api.nvim_win_is_valid(M.popup_win) then
    local marks = {}
    local valid = true
    local content = vim.api.nvim_buf_get_lines(M.popup_buf, 0, -1, true)
    for linenr, line_str in ipairs(content) do
      local pos_str, file_str = line_str:match('^(%d+)%s(.+)')
      local pos_val = tonumber(pos_str)
      if pos_str and pos_val and file_str then
        local mark_i = M.state.marks[linenr] -- can be nil
        local expect = nil
        if mark_i then
          expect = M.func.print_entry(mark_i)
          if line_str == expect then marks[linenr] = mark_i end
        end
        if not expect or line_str ~= expect then
          -- find what was moved to this line
          local matched = false
          for ind in pairs(M.state.marks) do
            local pot_mark = M.state.marks[ind]
            if pot_mark then
              local pot_fname = vim.fn.fnamemodify(pot_mark.argname, ':.')
              if file_str == pot_fname then
                local new_pos = linenr
                if linenr == pot_mark.markindex then new_pos = pos_val end
                local mark = {
                  argname = pot_mark.argname,
                  markindex = new_pos,
                  argindex = pot_mark.argindex,
                }
                marks[new_pos] = mark
                matched = true
                break
              end
            end
          end
          if not matched then
            vim.notify(
              'Not a valid mark: ' .. file_str,
              vim.log.levels.WARN,
              { title = 'Argmada' }
            )
            valid = false
            break
          end
        end
      end
    end
    if valid then
      M.func.apply_state()
      M.state.marks = marks
      if M.config.enable_autosave then M.func.save_state() end
    end
  end
end

--- Select mark based on current cursor line, should only be bound in the UI buffer
function M.func.select_via_ui()
  M.func.sync_ui()
  M.func.select(vim.fn.line('.'))
end

--
-- Functions
--

--- Save plugin state to disk
function M.func.save_state()
  local savefilename = M.state.savefilename or M.func.get_save_file_name()
  if not savefilename then return end

  local dir = vim.fn.fnamemodify(savefilename, ':h')
  if vim.fn.isdirectory(dir) == 0 then
    if vim.fn.mkdir(dir, 'p') == 0 then
      vim.notify(
        string.format('Cannot save state (mkdir failed for: %s)', dir),
        vim.log.levels.ERROR,
        { title = 'Argmada' }
      )
      return
    end
  end

  local file, err = io.open(savefilename, 'w')
  if not file then
    vim.notify(
      string.format('Cannot save state (file open failed: %s)', err),
      vim.log.levels.ERROR,
      { title = 'Argmada' }
    )
    return
  end

  -- we don't need to save everything in the state, strip out unnecessary stuff
  local original_marks = M.state.marks
  local marks_copy = vim.deepcopy(original_marks)
  for _, mark in pairs(marks_copy) do
    mark.loaded = nil
    mark.argindex = nil
  end
  M.state.marks = marks_copy
  -- already copied the savefilename at the beginning of the function
  M.state.savefilename = nil

  local ok, encoded_state = pcall(vim.json.encode, M.state)

  M.state.marks = original_marks
  M.state.savefilename = savefilename

  if not ok then
    file:close()
    vim.notify(
      'Failed to encode state: ' .. tostring(encoded_state),
      vim.log.levels.ERROR,
      { title = 'Argmada' }
    )
    return
  end

  file:write(encoded_state)
  file:flush()
  file:close()

  if not M.config.enable_autosave then
    vim.notify('Saved state', vim.log.levels.INFO, { title = 'Argmada' })
  end
end

--- Load plugin state from disk
--- extends current state with the state, no change if no save available
function M.func.load_state()
  -- load it based on cwd, then keep it, even if cwd changes
  local savefilename = M.state.savefilename or M.func.get_save_file_name()
  if not savefilename then return end

  local file = io.open(savefilename, 'r')
  if not file then
    if not M.config.enable_autosave then
      vim.notify('No saved state found', vim.log.levels.INFO, { title = 'Argmada' })
    end
    return
  end

  local readstate = vim.json.decode(file:read('*a'))
  file:close()
  M.state.current = readstate.current
  for key, value in ipairs(readstate.marks) do
    if value ~= vim.NIL then
      local entry = {
        loaded = false, -- on fresh load want to use last_line
        markindex = value.markindex,
        argname = value.argname,
        last_line = value.last_line,
        argindex = -1, -- init occurs during apply_state()
      }
      M.state.marks[key] = entry
    end
  end
  M.func.apply_state()
  if not M.config.enable_autosave then
    vim.notify('Loaded state', vim.log.levels.INFO, { title = 'Argmada' })
  end
end

--- Add or update a mark at the given index (or append if no index given)
function M.func.mark(index)
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == '' then
    vim.notify(
      'Cannot mark an unnamed buffer',
      vim.log.levels.WARN,
      { title = 'Argmada' }
    )
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
        vim.notify(
          string.format('Buffer already marked (index: %d)', k),
          vim.log.levels.INFO,
          { title = 'Argmada' }
        )
        return -- exit
      end
    end
  end

  if not index then
    if M.config.append_to_end then
      -- append at the end of the list, skipping over gaps
      local max_idx = 0
      for k in pairs(M.state.marks) do
        if k > max_idx then max_idx = k end
      end
      index = max_idx + 1
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

  M.func.apply_state()
  if M.config.enable_autosave then M.func.save_state() end
  if _debug then vim.notify('Argmada: Marked at ' .. index, vim.log.levels.DEBUG) end
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
    M.func.apply_state()
    if M.config.enable_autosave then M.func.save_state() end
    if _debug then
      vim.notify('Argmada: Removed mark ' .. index, vim.log.levels.DEBUG)
    end
  else
    vim.notify(
      'No mark to remove for this buffer',
      vim.log.levels.INFO,
      { title = 'Argmada' }
    )
  end
end

--- Jump to the mark given by the index argument
---@param index integer
function M.func.select(index)
  local mark = M.state.marks[index]
  if not mark then
    vim.notify(
      'No mark for index ' .. tostring(index),
      vim.log.levels.INFO,
      { title = 'Argmada' }
    )
    return
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
    vim.notify('Argmada: Failed to jump - ' .. tostring(err), vim.log.levels.ERROR)
  end
end

--- Jump to the next available mark (wraps around)
function M.func.select_next()
  if not M.state.current then return end
  local next_idx = M.state.current + 1
  local max_idx = 0
  -- Find the highest logical index
  for k in pairs(M.state.marks) do
    if k > max_idx then max_idx = k end
  end
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
  local max_idx = 0
  for k in pairs(M.state.marks) do
    if k > max_idx then max_idx = k end
  end
  while max_idx > M.state.current do
    if M.state.marks[max_idx] then
      M.func.select(max_idx)
      return
    end
    max_idx = max_idx - 1
  end
end

--- Close the UI, state sync is handled by autocmd (set in open_ui)
function M.func.close_ui()
  if M.popup_win == nil then return end
  if M.popup_win and vim.api.nvim_win_is_valid(M.popup_win) then
    vim.api.nvim_win_close(M.popup_win, true)
  end
  M.popup_win = nil
  M.popup_buf = nil
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
  local lines_count = 0
  for k in pairs(M.state.marks) do
    if k > lines_count then lines_count = k end
  end
  local height = lines_count + M.config.ui_after_padding
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
  for i = 1, lines_count do
    local v = M.state.marks[i]
    if v then
      table.insert(lines, M.func.print_entry(v))
    else
      table.insert(lines, ' ') -- Empty line for empty slot
    end
  end

  vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, lines)
  -- place cursor on last jump
  local cursor_pos = M.state.current or 1
  vim.cmd('norm! ' .. cursor_pos .. 'G')
  -- auto close the window if buffer or window changes
  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
    group = M.augroup,
    buffer = popup_buf,
    callback = function()
      if M.popup_buf ~= nil then
        M.func.sync_ui()
        M.func.close_ui()
      end
    end,
  })
  -- set keymaps
  for _, mapping in ipairs(M.config.keymaps.ui) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('n', key, function()
      action(unpack(args))
    end, { buffer = popup_buf })
  end
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
---@param opts table?
function M.setup(opts)
  if M.plugin_loaded then return end
  M.plugin_loaded = true
  M.augroup = vim.api.nvim_create_augroup('Argmada.au', {})

  if opts and not opts.keep_default_binds then M.config.keymaps = {} end

  M.config = vim.tbl_deep_extend('force', default_config, opts or {})

  if M.config.enable_autosave then
    keybind_map['save'] = function()
      vim.notify('Save disabled', vim.log.levels.INFO, { title = 'Argmada' })
    end
    keybind_map['load'] = function()
      vim.notify('Load disabled', vim.log.levels.INFO, { title = 'Argmada' })
    end

    -- handle lazy loading
    if vim.v.vim_did_enter == 1 then
      M.func.load_state()
    else
      vim.api.nvim_create_autocmd('VimEnter', {
        group = M.augroup,
        callback = function()
          M.func.load_state()
        end,
      })
    end
    -- save before exit
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = M.augroup,
      callback = function()
        local has_marks = false
        for _ in pairs(M.state.marks) do
          has_marks = true
          break
        end
        if has_marks then M.func.save_state() end
      end,
    })
  end

  for _, mapping in ipairs(M.config.keymaps.normal or {}) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('n', key, function()
      action(unpack(args))
    end, mapping[4] or {})
  end

  for _, mapping in ipairs(M.config.keymaps.visual or {}) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('v', key, function()
      action(unpack(args))
    end, mapping[4] or {})
  end

  for _, mapping in ipairs(M.config.keymaps.insert or {}) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('i', key, function()
      action(unpack(args))
    end, mapping[4] or {})
  end

  vim.schedule(function()
    M.func.garbage_collect()
  end)
end

-- return M

vim.schedule(function()
  M.setup()
end)
