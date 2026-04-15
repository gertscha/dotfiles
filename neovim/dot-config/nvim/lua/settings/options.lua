-- :help options
-- for full list and detailed explanation

-- reduce log (usually .local/state/nvim/lsp.log)
vim.lsp.log.set_level(vim.lsp.log.levels.WARN)

vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.breakindent = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.textwidth = 0
vim.o.colorcolumn = '80'
vim.o.shiftround = true -- Round when indenting with <<,>>
-- close folds automatically, based on level, adjust with: zr & zm
vim.o.foldclose = 'all'

vim.o.winborder = 'rounded'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.winminwidth = 5
vim.o.helpheight = 999
vim.o.signcolumn = 'yes'
vim.o.foldcolumn = 'auto'
vim.o.scrolloff = 5
vim.o.conceallevel = 0
vim.o.showmode = false -- status line shows mode
vim.o.laststatus = 0 -- disable default status bar

vim.o.incsearch = true
vim.o.completeopt = 'noselect,noinsert'
vim.o.list = true
vim.o.listchars =
  'trail:·,multispace:·,leadmultispace: ,precedes:,extends:,tab: '
vim.o.showbreak = '󰖶'
vim.o.cursorline = true
vim.o.cursorlineopt = 'line,number'
vim.o.display = 'lastline,uhex'
-- vim.o.formatoptions = 'croqnjl' -- tcj
vim.o.diffopt = 'closeoff,filler,followwrap,internal,iwhiteeol'
vim.o.sessionoptions = 'buffers,sesdir,localoptions,options,winsize,tabpages'
vim.o.matchpairs = '(:),{:},[:],<:>'

vim.o.hidden = true
vim.o.confirm = true
-- mouse enabled but right-click popups removed
vim.o.mouse = 'nvh'
vim.cmd [[
  aunmenu PopUp
  autocmd! nvim.popupmenu
]]
vim.o.shell = 'fish'
vim.o.clipboard = 'unnamedplus'
vim.o.termguicolors = true
vim.o.updatetime = 400 -- idle time until swap file is written and CursorHold
vim.o.timeoutlen = 800 -- keybind sequence timeout length

vim.o.cpoptions = 'aABceFs_q~'
vim.o.undofile = true
vim.o.undolevels = 20000
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = true

vim.o.modeline = false

vim.g.tex_flavor = 'latex'
vim.g.have_nerd_font = true
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

vim.api.nvim_set_var('loaded_perl_provider', 0)
vim.api.nvim_set_var('loaded_python3_provider', 0)
vim.api.nvim_set_var('loaded_node_provider', 0)
vim.api.nvim_set_var('loaded_ruby_provider', 0)

-- Enable the experimental feature intended to replace the builtin message +
-- cmdline presentation layer, see :h ui2
require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = 'cmd', -- 'cmd'|'msg'
  },
})
