-- auto resize buffers
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- visual feedback for yank
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('settings-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'Visual', timeout = 150 })
  end,
})

-- Hide cursorline when the window doesn't have focus
vim.api.nvim_create_autocmd({ 'WinLeave', 'FocusLost' }, {
  callback = function()
    if not vim.opt.diff:get() and not vim.opt.cursorbind:get() then
      vim.opt_local.cursorline = false
    end
  end,
})
vim.api.nvim_create_autocmd({ 'WinEnter', 'FocusGained' }, {
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- Hide trailing spaces markers in insert mode
local trailchar = nil
vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    local listchars = vim.opt_local.listchars:get()
    if listchars then
      trailchar = listchars.trail
      listchars.trail = ' '
      vim.opt_local.listchars = listchars
    end
  end,
})
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = function()
    local listchars = vim.opt_local.listchars:get()
    if trailchar and listchars then
      listchars.trail = trailchar
      vim.opt_local.listchars = listchars
    end
  end,
})

-- Check if there is an OPAM switch when opening Ocaml files (only once)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'ocaml', 'dune' },
  once = true,
  callback = function()
    local switch = os.getenv('OPAM_SWITCH_PREFIX')
    if not switch then
      vim.notify('No OPAM switch detected', vim.log.levels.ERROR)
    elseif string.find(switch, 'default') then
      vim.notify('Using default OPAM switch: ' .. switch, vim.log.levels.WARN)
    end
  end,
})
