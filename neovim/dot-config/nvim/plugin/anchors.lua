-- Small Harpoon like plugin

-- TODO add some garbage collection somewhere to remove old saves
-- TODO lazy load when possible

--- enable debug messages
local _debug = false

---@class MarkElement
---@field bufnr integer?
---@field filename string
---@field markindex integer
---@field linepos integer

---@class AnchorState
---@field savefilename string?
---@field current integer?
---@field marks table<integer, MarkElement>

---@class AnchorConfig
---@field enable_autosave boolean
---@field after_padding integer
---@field keep_default_binds boolean
---@field allow_duplicates boolean
---@field keymaps table

---@class AnchorFunctions
---@field save_state function
---@field load_state function
---@field mark function
---@field mark_buffer function
---@field unmark function
---@field unmark_buffer function
---@field unmark_current_buffer function
---@field select function
---@field select_next function
---@field select_prev function
---@field toggle_ui function
---@field open_ui function
---@field close_ui function
---@field ui_goto function
---@field sync function
---@field clear_marks_for function
---@field print_entry function
---@field get_save_file_name function

---@class AnchorPlugin
---@field setup function
---@field config AnchorConfig
---@field func AnchorFunctions
---@field state AnchorState
---@field loaded boolean
---@field augroup integer?
---@field popup_win integer?
---@field popup_buf integer?

-- used to map keymaps in the config to functions in M.func
local keybind_map = {}

---@type AnchorConfig
local default_config = {
  enable_autosave = true,
  after_padding = 3,
  keep_default_binds = true,
  allow_duplicates = false,
  keymaps = {
    normal = {
      { '<C-s>', 'mark', {}, { desc = 'Anchor: Append new Mark' } },
      { '<C-h>', 'toggle_ui', {}, { desc = 'Anchor: Toggle UI' } },
      { '<leader>am', 'mark', { 1 }, { desc = 'Anchor: Mark 1' } },
      { '<leader>an', 'mark', { 2 }, { desc = 'Anchor: Mark 2' } },
      { '<leader>ab', 'mark', { 3 }, { desc = 'Anchor: Mark 3' } },
      { '<leader>av', 'mark', { 4 }, { desc = 'Anchor: Mark 4' } },
      { '<leader>m', 'select', { 1 }, { desc = 'Anchor: Go to 1' } },
      { '<leader>n', 'select', { 2 }, { desc = 'Anchor: Go to 2' } },
      { '<leader>b', 'select', { 3 }, { desc = 'Anchor: Go to 3' } },
      { '<leader>v', 'select', { 4 }, { desc = 'Anchor: Go to 4' } },
      { '[h', 'prev', {}, { desc = 'Anchor: previous Mark' } },
      { ']h', 'next', {}, { desc = 'Anchor: next Mark' } },
      -- { '<leader>hs', 'save', {}, { desc = 'Anchor: Save' } },
      -- { '<leader>hl', 'load', {}, { desc = 'Anchor: Load' } },
      { '<leader>hc', 'unmark', {}, { desc = 'Anchor: Remove Mark' } },
      -- { '<leader>hm', 'unmark', { 1 }, { desc = 'Anchor: Remove Mark 1' } },
    },
    visual = {},
    insert = {},
    ui = {
      { '<CR>', 'ui_select' },
      { 'q', 'close_ui' },
      { '<ESC>', 'close_ui' },
    },
  },
}

---@type AnchorPlugin
local AP = {
  setup = nil, ---@diagnostic disable-line:assign-type-mismatch
  func = {}, ---@diagnostic disable-line:missing-fields
  config = default_config,
  state = {
    savefilename = nil,
    current = nil,
    marks = {},
  },
  loaded = false,
  augroup = nil,
  popup_win = nil,
  popup_buf = nil,
}

--
-- Functions
--

--- INTERNAL: determine the save file name (based on cwd)
---@return string?
function AP.func.get_save_file_name()
  local statedir = vim.fn.stdpath('data') .. '/anchors'
  local basedir = vim.uv.cwd()
  if type(basedir) ~= 'string' then
    vim.notify(
      'Cannot determine save file name (get cwd failed)',
      vim.log.levels.ERROR,
      { title = 'Anchors' }
    )
    return nil
  end
  local strip_home = string.gsub(vim.fn.fnamemodify(basedir, ':~'), '~/', '')
  local basename = string.gsub(string.gsub(strip_home, '%.', 'd'), '/', '-')
  if string.sub(basename, 1, 1) == '-' then basename = string.sub(basename, 2) end
  return statedir .. '/' .. basename .. '-state.json'
end

--- Save plugin state to disk
function AP.func.save_state()
  if not AP.state.savefilename then
    AP.state.savefilename = AP.func.get_save_file_name()
    if not AP.state.savefilename then return end
  end
  local file, err = io.open(AP.state.savefilename, 'w')
  if not file then
    -- intermediate directories may be missing, try to create them
    local dir = vim.fn.fnamemodify(AP.state.savefilename, ':h')
    if not vim.fn.mkdir(dir, 'p') then
      vim.notify(
        string.format('Cannot save state (mkdir failed: %s)', err),
        vim.log.levels.ERROR,
        { title = 'Anchors' }
      )
      return
    end
    -- try opening again
    file, err = io.open(AP.state.savefilename, 'w')
    if not file then
      vim.notify(
        string.format('Cannot save state (file open failed: %s)', err),
        vim.log.levels.ERROR,
        { title = 'Anchors' }
      )
      return
    end
  end
  file:write(vim.json.encode(AP.state))
  file:flush()
  file:close()
  if not AP.config.enable_autosave then
    vim.notify('Saved state', vim.log.levels.INFO, { title = 'Anchors' })
  end
end

--- Load plugin state from disk
--- extends current state with the state, no change if no save available
function AP.func.load_state()
  if not AP.state.savefilename then
    AP.state.savefilename = AP.func.get_save_file_name()
    if not AP.state.savefilename then return end
  end
  local file = io.open(AP.state.savefilename, 'r')
  -- no save file exists, just keep the current one
  if not file then
    if not AP.config.enable_autosave then
      vim.notify('No saved state found', vim.log.levels.INFO, { title = 'Anchors' })
    end
    return
  end
  -- load the data, refresh the bufnr values
  local readstate = vim.json.decode(file:read('*a'))
  file:close()
  AP.state.savefilename = readstate.savefilename
  AP.state.current = readstate.current
  -- restore the marks
  for key, value in ipairs(readstate.marks) do
    if value ~= vim.NIL then
      local entry = {}
      entry.bufnr = nil
      entry.filename = value.filename
      entry.markindex = value.markindex
      entry.linepos = value.linepos
      AP.state.marks[key] = entry
    end
  end
  if not AP.config.enable_autosave then
    vim.notify('Loaded state', vim.log.levels.INFO, { title = 'Anchors' })
  end
end

--- INTERNAL: Mark current buffer (and pos) in Mark list at argument index
---@param index integer
function AP.func.mark_buffer(index)
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.fn.bufname(bufnr)
  if filename == '' then
    vim.notify(
      'Cannot save unnamed buffer',
      vim.log.levels.INFO,
      { title = 'Anchors' }
    )
    return
  end
  if not AP.config.allow_duplicates then AP.func.clear_marks_for(filename) end
  local entry = {}
  entry.filename = filename
  entry.markindex = index
  entry.bufnr = bufnr
  entry.linepos = vim.fn.line('.')

  AP.state.marks[index] = entry
  AP.state.current = index

  if AP.config.enable_autosave then AP.func.save_state() end
end

--- Mark the current buffer (and pos) to Mark list
--- Without arguments will append to end of the Mark list
--- Integer argument will use the argument index
---@param index integer?
function AP.func.mark(index)
  if index then
    AP.func.mark_buffer(index)
  else
    local i = 0
    for k in pairs(AP.state.marks) do
      if k >= i then i = k + 1 end
    end
    AP.func.mark_buffer(i)
  end
end

--- INTERNAL: Remove the mark at argument index
---@param index integer
function AP.func.unmark_buffer(index)
  AP.state.marks[index] = nil

  if AP.config.enable_autosave then AP.func.save_state() end
end

--- INTERNAL: Remove the mark for current buffer
function AP.func.unmark_current_buffer()
  local filename = vim.fn.bufname()
  for i, val in ipairs(AP.state.marks) do
    if filename == val.filename then AP.state.marks[i] = nil end
  end

  if AP.config.enable_autosave then AP.func.save_state() end
end

--- Remove a mark, pass index to clear or leave empty to implicitly choose
--- the current active buffer
---@param index integer?
function AP.func.unmark(index)
  if index then
    AP.func.unmark_buffer(index)
  else
    AP.func.unmark_current_buffer()
  end
end

--- INTERNAL: Remove all marks that point to the argument file
---@param filename string
function AP.func.clear_marks_for(filename)
  for k in pairs(AP.state.marks) do
    local mark = AP.state.marks[k]
    if mark.filename == filename then AP.func.unmark_buffer(mark.markindex) end
  end
end

--- Jump to the mark given by the index argument
---@param index integer
function AP.func.select(index)
  local entry = AP.state.marks[index]
  if not entry then
    vim.notify('No mark for this index', vim.log.levels.INFO, { title = 'Anchors' })
    return
  end
  if not entry.bufnr then
    -- get the buffer or create it
    local bufnr = vim.fn.bufadd(entry.filename)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
      vim.api.nvim_set_option_value('buflisted', true, { buf = bufnr })
    end
    entry.bufnr = bufnr
  end
  -- clamp line position to keep it valid
  local lines = vim.api.nvim_buf_line_count(entry.bufnr)
  if entry.linepos > lines then entry.linepos = lines end
  -- switch to the entry
  vim.api.nvim_set_current_buf(entry.bufnr)
  vim.fn.setpos('.', { entry.bufnr, entry.linepos, 1, 1 })

  AP.state.current = index
end

--- Jump to the next mark (based on previous jumps), wraps around
function AP.func.select_next()
  local prev = AP.state.current or 1
  while prev + 1 < #AP.state.marks and AP.state.marks[prev + 1] == nil do
    prev = prev + 1
  end
  if prev == #AP.state.marks then prev = 0 end
  AP.func.select(prev + 1)
end

--- Jump to the previous mark (based on previous jumps), wraps around
function AP.func.select_prev()
  local prev = AP.state.current or 1
  while prev - 1 > 0 and AP.state.marks[prev - 1] == nil do
    prev = prev - 1
  end
  if prev == 1 then prev = #AP.state.marks + 1 end
  AP.func.select(prev - 1)
end

--- INTERNAL: Get the pretty string of a MarkElement
---@param mark MarkElement
---@return string
function AP.func.print_entry(mark)
  local label = vim.fn.fnamemodify(mark.filename, ':~:.')
  return string.format('%i %s', mark.markindex, label)
end

--- INTERNAL: Sync the UI buffer state to plugin state
--- only updates if the UI buffer is valid, otherwise changes are discarded
function AP.func.sync()
  if _debug then vim.notify('Anchor: Called Sync()', vim.log.levels.DEBUG) end
  if AP.popup_win and vim.api.nvim_win_is_valid(AP.popup_win) then
    local marks = {}
    local valid = true
    local content = vim.api.nvim_buf_get_lines(AP.popup_buf, 0, -1, true)
    for linenr, line_str in ipairs(content) do
      local pos_str, file_str = line_str:match('^(%d+)%s(.+)')
      local pos_val = tonumber(pos_str)
      if pos_str and pos_val and file_str then
        local mark_i = AP.state.marks[linenr] -- can be nil
        local expect = nil
        if mark_i then
          expect = AP.func.print_entry(mark_i)
          if line_str == expect then marks[linenr] = mark_i end
        end
        if not expect or line_str ~= expect then
          -- find what was moved to this line
          local matched = false
          for ind in pairs(AP.state.marks) do
            local pot_mark = AP.state.marks[ind]
            if pot_mark then
              local pot_fname = vim.fn.fnamemodify(pot_mark.filename, ':~:.')
              if file_str == pot_fname then
                local new_pos = linenr
                if linenr == pot_mark.markindex then new_pos = pos_val end
                local mark = { bufnr = pot_mark.bufnr }
                mark.filename = pot_mark.filename
                mark.linepos = pot_mark.linepos
                mark.markindex = new_pos
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
              { title = 'Anchors' }
            )
            valid = false
            break
          end
        end
      end
    end
    if valid then
      AP.state.marks = marks
      if AP.config.enable_autosave then AP.func.save_state() end
    end
  end
end

--- Select mark based on current cursor line
function AP.func.ui_goto()
  AP.func.sync()
  AP.func.select(vim.fn.line('.'))
end

--- Close the UI, state sync is handled by autocmd (set in open_ui)
function AP.func.close_ui()
  if _debug then vim.notify('Anchor: close_ui()', vim.log.levels.DEBUG) end
  if AP.popup_win == nil then return end
  if AP.popup_win and vim.api.nvim_win_is_valid(AP.popup_win) then
    if _debug then vim.notify('Anchor: close_ui() if', vim.log.levels.DEBUG) end
    vim.api.nvim_win_close(AP.popup_win, true)
  end
  AP.popup_win = nil
  AP.popup_buf = nil
  if _debug then vim.notify('Anchor: close_ui() end', vim.log.levels.DEBUG) end
end

--- Open the UI window
function AP.func.open_ui()
  -- if already open nothing to be done
  if AP.popup_win and vim.api.nvim_win_is_valid(AP.popup_win) then return end
  -- create the popup buffer
  local popup_buf = vim.api.nvim_create_buf(false, true)
  AP.popup_buf = popup_buf
  vim.bo[popup_buf].bufhidden = 'wipe'
  vim.bo[popup_buf].filetype = 'anchor-popup'
  vim.bo[popup_buf].buftype = 'nofile'
  vim.bo[popup_buf].bufhidden = 'wipe'
  -- create the popup window and open the buffer in it
  local lines_count = 0
  for k in pairs(AP.state.marks) do
    if k > lines_count then lines_count = k end
  end
  local height = lines_count + AP.config.after_padding
  local width = 80
  local row = math.ceil((vim.o.lines - height) / 2)
  local col = math.ceil((vim.o.columns - width) / 2)
  local popup_win = vim.api.nvim_open_win(popup_buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    title = ' Anchors ',
    title_pos = 'center',
    style = 'minimal',
  })
  AP.popup_win = popup_win
  vim.wo[popup_win].cursorline = true
  vim.wo[popup_win].number = false
  vim.wo[popup_win].wrap = false
  -- set the content of the popup buffer
  local lines = {}
  for k, v in pairs(AP.state.marks) do
    while #lines + 1 < k do
      table.insert(lines, ' ') -- empty marks get empty lines
    end
    table.insert(lines, AP.func.print_entry(v))
  end
  for _ = 1, AP.config.after_padding do
    table.insert(lines, ' ')
  end
  vim.api.nvim_buf_set_lines(popup_buf, 0, -1, false, lines)
  -- place cursor on last jump
  local cursor_pos = AP.state.current or 1
  vim.cmd('norm! ' .. cursor_pos .. 'G')
  -- auto close the window if buffer or window changes
  vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
    group = AP.augroup,
    buffer = popup_buf,
    callback = function(ev)
      if _debug then vim.notify('Anchor: Au triggered', vim.log.levels.DEBUG) end
      if AP.popup_buf ~= nil then
        AP.func.sync()
        AP.func.close_ui()
      end
    end,
  })
  -- set keymaps
  for _, mapping in ipairs(AP.config.keymaps.ui) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('n', key, function()
      vim.fn.call(action, args)
    end, { buffer = popup_buf })
  end
end

--- Toggle the UI window
function AP.func.toggle_ui()
  if AP.popup_buf ~= nil and AP.popup_win ~= nil then
    AP.func.close_ui()
  else
    AP.func.open_ui()
  end
end

-- interface functions and what they map to
-- allows config to manipulate this before the keybinds are set
-- hopefully allows the config interface to be more stable
keybind_map = {
  ['mark'] = AP.func.mark, -- args: optional index
  ['unmark'] = AP.func.unmark, -- args: optional index
  ['toggle_ui'] = AP.func.toggle_ui,
  ['open_ui'] = AP.func.open_ui,
  ['close_ui'] = AP.func.close_ui,
  ['save'] = AP.func.save_state,
  ['load'] = AP.func.load_state,
  ['select'] = AP.func.select, -- args: index
  ['next'] = AP.func.select_next,
  ['prev'] = AP.func.select_prev,
  ['ui_select'] = AP.func.ui_goto,
}

--
-- Setup
--

--- Init the plugin
--- Override default config with opts argument
---@param opts table?
AP.setup = function(opts)
  if AP.loaded then return end
  AP.loaded = true
  AP.augroup = vim.api.nvim_create_augroup('Anchor.au', {})

  if opts and not opts.keep_default_binds then AP.config.keymaps = {} end

  AP.config = vim.tbl_deep_extend('force', default_config, opts or {})

  if AP.config.enable_autosave then
    keybind_map['save'] = function()
      vim.notify('Save disabled', vim.log.levels.INFO, { title = 'Anchors' })
    end
    keybind_map['load'] = function()
      vim.notify('Load disabled', vim.log.levels.INFO, { title = 'Anchors' })
    end

    vim.api.nvim_create_autocmd('VimEnter', {
      group = AP.augroup,
      callback = function(ev)
        AP.func.load_state()
      end,
    })
    vim.api.nvim_create_autocmd('VimLeavePre', {
      group = AP.augroup,
      callback = function(ev)
        if #AP.state.marks > 0 then AP.func.save_state() end
      end,
    })
  end

  for _, mapping in ipairs(AP.config.keymaps.normal or {}) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('n', key, function()
      vim.fn.call(action, args)
    end, mapping[4] or {})
  end

  for _, mapping in ipairs(AP.config.keymaps.visual or {}) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('v', key, function()
      vim.fn.call(action, args)
    end, mapping[4] or {})
  end

  for _, mapping in ipairs(AP.config.keymaps.insert or {}) do
    local key = mapping[1]
    local action = keybind_map[mapping[2]]
    local args = mapping[3] or {}
    vim.keymap.set('i', key, function()
      vim.fn.call(action, args)
    end, mapping[4] or {})
  end
end

-- return M
AP.setup()
