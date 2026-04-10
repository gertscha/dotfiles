-- auto resize buffers
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('auto-resize-buf', { clear = true }),
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
  group = vim.api.nvim_create_augroup('hide-inactive-cursorline', { clear = true }),
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
  group = vim.api.nvim_create_augroup('hide-trailing-in-insert', { clear = true }),
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

-- add keybinds to close the cmd win history
vim.api.nvim_create_autocmd('CmdwinEnter', {
  group = vim.api.nvim_create_augroup('close-cmd-window', { clear = true }),
  callback = function(args)
    if vim.g.requested_cmdwin then
      local opts = { buffer = args.buf, silent = true }
      vim.keymap.set('n', '<Esc>', '<CMD>q<CR>', opts)
      vim.keymap.set('n', '<A-q>', '<CMD>q<CR>', opts)
      vim.g.requested_cmdwin = nil
    else
      vim.cmd('quit')
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

-- Make opening large files more performant
local big_file_group =
  vim.api.nvim_create_augroup('big-file-setup', { clear = true })
vim.api.nvim_create_autocmd('BufReadPre', {
  desc = 'Disable expensive features for massive files',
  group = big_file_group,
  callback = function(args)
    -- threshold (20MB)
    local max_filesize = 20 * 1024 * 1024

    local file = args.match
    local ok, stats = pcall(vim.uv.fs_stat, file)
    if ok and stats and stats.size > max_filesize then
      vim.b[args.buf].is_large_file = true -- add a tag

      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].undofile = false
      -- Clear syntax safely after the buffer is fully loaded
      vim.schedule(function()
        vim.bo[args.buf].syntax = ''
      end)

      vim.notify('Syntax, Undo, etc disabled for performance', vim.log.levels.INFO)
    end
  end,
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  group = big_file_group,
  desc = 'Disable window folding for massive files',
  callback = function(args)
    -- use the tag from the BufReadPre autocmd
    if vim.b[args.buf].is_large_file then vim.wo.foldmethod = 'manual' end
  end,
})
