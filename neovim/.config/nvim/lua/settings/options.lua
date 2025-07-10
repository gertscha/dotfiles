-- :help options
-- for full list and detailed explanation

local opt = vim.o

-- backup current file, deleted afterwards (default)
opt.backup = false
opt.writebackup = true
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.autowrite = false -- Enable auto write if the buffer changes
opt.hidden = true -- Allow buffers to exist in the background, otherwise
-- you need to save before switching buffers, also needed for Toggleterm

opt.clipboard = 'unnamedplus' -- Sync with system clipboard
opt.mouse = 'a' -- Enable mouse mode
-- opt.spelllang = { "en" }
-- opt.fileencoding = "utf-8" -- is the default value
opt.termguicolors = true -- True color support
vim.g.have_nerd_font = true

vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings
opt.conceallevel = 0 -- show all markup in markdown files
opt.cursorline = true -- Enable highlighting of the current line
opt.hlsearch = false -- highlight all matches on previous search pattern
-- disable auto select on insert (blink.cmp has its own settings for that)
opt.completeopt = 'noselect,noinsert'
opt.laststatus = 0 -- change when the last window has a status line, 0 never, 2 default
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.showmode = false -- Dont show mode since we have a statusline
opt.numberwidth = 4 -- set number column width {default 4}
opt.winminwidth = 5 -- Minimum window width
opt.list = true -- Show characters based on 'listchars' option
-- show trailing white spaces and tabs (tabs should be converted to spaces automatically)
opt.listchars = 'trail:·,tab: ' -- alternative for trailing spaces: (␣)
opt.signcolumn = 'yes' -- Always show the signcolumn, prevent text shifting around
opt.colorcolumn = '80' -- indicate the 80th column visually
opt.inccommand = 'split' -- preview incremental substitute
opt.number = true -- Print line number
opt.relativenumber = true -- set relative numbered lines
opt.winborder = 'rounded' -- sets the default border for all floating windows
opt.helpheight = 999 -- make help windows take up whole screen

opt.formatoptions = 'croqnjl' -- tcj
--opt.grepformat = "%f:%l:%c:%m"
--opt.grepprg = "rg --vimgrep"
--opt.shortmess:append({ W = true, I = true, c = true })
opt.shiftround = true -- Round indent
--opt.iskeyword:append("-") -- hyphenated words recognized by a single word
opt.wildmode = 'longest:full,full' -- Command-line completion mode
opt.foldenable = false -- Disable folding at startup.

opt.smartcase = true -- Don't ignore case with capitals
opt.ignorecase = true -- Ignore case in patterns

opt.autoindent = true -- Copy indents from current line
opt.smartindent = true -- Insert indents automatically

-- Changes the effect of the |:mksession| command.
opt.sessionoptions = 'buffers,sesdir,winsize,tabpages'

opt.sidescrolloff = 8 -- Columns of context
opt.scrolloff = 5 -- Lines of context

opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current

opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 4 -- Number of spaces tabs count for
opt.shiftwidth = 4 -- Size of an indent
opt.softtabstop = 4

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

opt.undofile = true
--opt.undodir = "~/.nvim/undo"
opt.undolevels = 10000

opt.timeoutlen = 300
opt.updatetime = 200 -- Save swap file and trigger CursorHold

-- configure netrw
-- vim.g.netrw_winsize = 30
-- vim.g.netrw_keepdir = 0
-- vim.g.netrw_banner = 0 -- use 'I' to show it again
-- vim.g.netrw_sort_sequence = [[[\/]$,*]] -- Show directories first (sorting)
-- vim.g.netrw_liststyle = 0 -- long list, cycle with 'i'

-- disable some providers (i don't use any plugins that need them)
vim.api.nvim_set_var('loaded_perl_provider', 0)
vim.api.nvim_set_var('loaded_python3_provider', 0)
vim.api.nvim_set_var('loaded_node_provider', 0)
vim.api.nvim_set_var('loaded_ruby_provider', 0)

-- prevent small latex files from being recognized as 'plaintex'
vim.g.tex_flavor = 'latex'
