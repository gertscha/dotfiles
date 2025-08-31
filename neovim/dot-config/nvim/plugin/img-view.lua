-- Still WIP
-- Small plugin to get image previews for binary image files in nvim
-- uses chafa and overwrites the tty with the output
-- auto-triggering currently has some issues, but manual keybind works
-- on cursor move the preview gets removed

---@class Viewer
---@field config {value: any, context: any}
---@field state {value: any, context: any}
local Viewer = {}
Viewer.__index = Viewer

function Viewer:_display(row, col, width, height, image)
  -- getting the tty is not correct currently (i think)
  -- usin fzf-lua will cause it to stop working, assume it spawns some other
  -- threads and io.popen() gets one of those?
  local proc = assert(io.popen('tty'))
  local tty_name = proc:read()
  proc:close()

  -- vim.notify(string.format('size: %dx%d', width, height), vim.log.levels.INFO)

  local cmd = string.format('chafa -s %ix%i --colors 256 "%s"', width, height, image)
  local output = nil
  local handle = io.popen(cmd)
  if handle then
    output = handle:read('*all') -- Read all output
    handle:close()
  else
    vim.notify('failed to get blob', vim.log.levels.WARN)
    return
  end
  pcall(function()
    -- vim.notify('writing to tty', vim.log.levels.INFO)
    local stdout = assert(io.open(tty_name, 'ab'))
    -- format is: format(row, col)
    stdout:write(('\x1b[s\x1b[%d;%dH'):format(row, col))
    stdout:write(output)
    stdout:write('\x1b[u')
    stdout:close()
  end)
end

function Viewer:show(image)
  -- cpos: (row, col) tuple
  local cpos = vim.api.nvim_win_get_cursor(0)
  -- spos: table {row,col,endcol,curscol}
  local spos = vim.fn.screenpos(vim.fn.win_getid(), cpos[1] + 1, 0)
  local width = vim.o.columns - spos.col + 1
  local height = vim.o.lines - spos.row

  if self.state.au_cmd_id then self:clean() end

  self._display(self, spos.row, spos.col, width, height, image)

  local auid = vim.api.nvim_create_autocmd('CursorMoved', {
    group = self.state.augroup,
    callback = function(ev)
      self:clean()
    end,
  })

  self.state.au_cmd_id = auid
  self.state.showing = true
end

function Viewer:show_buf()
  local file = vim.fn.expand('%')
  self:show(file)
end

function Viewer:clean()
  if self.state.showing then
    vim.cmd('mode') -- clear screen
    -- https://github.com/neovim/neovim/issues/10279
    -- :redraw -> update_screen(0)
    -- :redraw! -> update_screen(NOT_VALID) <- not sufficient
    -- :mode -> update_screen(CLEAR) <- need this
    -- <C-L> -> update_screen(CLEAR)
    self.state.showing = false
    if self.state.au_cmd_id then
      vim.api.nvim_del_autocmd(self.state.au_cmd_id)
      self.state.au_cmd_id = nil
    end
  else
    vim.notify('No image showing', vim.log.levels.INFO)
  end
end

function Viewer.new()
  local newViewer = {
    config = config or {},
    state = {
      showing = false,
      hooks_setup = false,
      au_cmd_id = nil,
      namespace = nil,
      augroup = nil,
    },
  }
  setmetatable(newViewer, Viewer)

  return newViewer
end

---@param self Viewer
---@param partial_config
---@return Viewer
function Viewer.setup(self, partial_config)
  local defaults = {
    filetypes = {
      png = true,
      jpeg = true,
      jpg = true,
    },
  }

  partial_config = partial_config or {}
  local config = defaults
  for k, v in pairs(partial_config) do
    if k == 'filetypes' then
      config.filetypes = vim.tbl_extend('force', config.filetypes, v)
    else
      config[k] = v
    end
  end
  self.config = config

  local filetypes = config.filetypes

  local namespace = vim.api.nvim_create_namespace('Image.Viewer.ns')
  self.state.namespace = namespace
  local augroup = vim.api.nvim_create_augroup('Image.Viewer.au', {})
  self.state.augroup = augroup

  if self.state.hooks_setup == false then
    -- vim.api.nvim_create_autocmd('Filetype', {
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      group = augroup,
      callback = function(ev)
        if self.state.showing then self:clean() end
        local ft = vim.fn.expand('%:e')
        if filetypes[ft] == true then
          -- vim.notify('matching ft', vim.log.levels.INFO)
          vim.schedule(function()
            self:show_buf()
          end)
        end
      end,
    })
    self.state.hooks_setup = true
  end

  -- default keybinds
  vim.keymap.set('n', '<leader>tpc', function()
    self:clean()
  end, { noremap = true, silent = true, desc = 'Clear image' })
  vim.keymap.set('n', '<leader>tps', function()
    self:show_buf()
  end, { noremap = true, silent = true, desc = 'Show image' })
end

local the_viewer = nil
local function initmyviewer()
  if not the_viewer then
    the_viewer = Viewer:new()
    -- adjust the config here
    the_viewer:setup({
      -- filetypes = {
      --   jpg = false,
      -- },
    })
  end
  return the_viewer
end
-- Lazy load
vim.keymap.set('n', '<leader>tpc', function()
  local view = initmyviewer()
  view:clean()
end, { noremap = true, silent = true, desc = 'Clear image' })
vim.keymap.set('n', '<leader>tps', function()
  local view = initmyviewer()
  view:show_buf()
end, { noremap = true, silent = true, desc = 'Show image' })
