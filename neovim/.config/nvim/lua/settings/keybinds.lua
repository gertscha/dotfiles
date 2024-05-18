-- Shorten function name
local keymap = vim.keymap.set

-- little function to set the options
local function opts(desc)
  return { desc = ' ' .. desc, noremap = true, silent = true }
end

-- set leader key
keymap('', '<Space>', '<Nop>', opts(''))
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes
--   normal_mode = "n"
--   insert_mode = "i"
--   visual_mode = "v"
--   visual_block_mode = "x"
--   term_mode = "t"
--   command_mode = "c"

-- open file explorer in main buffer
-- keymap('n', '<leader>ea', function() vim.cmd.Lex("%:p:h") end, opts('Open netrw (current file)'))
-- keymap('n', '<leader>e', vim.cmd.Lex, opts('Open netrw (working directory)'))

-- move lines, now using a plugin for this
-- keymap('v', '<A-j>', ":m .+1<CR>==", opts('Move Lines Down'))
-- keymap('v', '<A-k>', ":m .-2<CR>==", opts('Move Lines Up'))
-- keymap('x', '<A-j>', ":m '>+1<CR>gv=gv", opts('Move Lines Down'))
-- keymap('x', '<A-k>', ":m '<-2<CR>gv=gv", opts('Move Lines Up'))

-- alternate command bind
-- keymap('n', '<leader><leader>', ':', opts('Open Commandline'))

-- select all bind
keymap('n', '<leader>ca', 'ggVG<cr>', opts('Select all'))

-- redo alternate bind
keymap('n', '<leader>r', '<C-r>', opts('Redo'))

-- Press jj to leave insert mode, convienent but janky
--keymap('i', 'jj', '<ESC>', opts('Go to Normal Mode'))

-- Stay in indent mode when moving lines left or right
keymap('v', '<', '<gv', opts('Indent to the left'))
keymap('v', '>', '>gv', opts('Indent to the right'))

-- toggle line length indicator, cc ~= colorcolumn
keymap('n', '<leader>th', "<cmd>let &cc = &cc == '' ? '80,120' : ''<enter>", opts('Toggle line lenght limit highlighting'))
-- toggle line wrap
keymap('n', '<leader>twl', "<cmd>set wrap!<enter>", opts('Toggle line wrap'))
-- toggle textwidth
keymap('n', '<leader>tw0', "<cmd>set textwidth=0<enter>", opts('Disable line lenght limit'))
keymap('n', '<leader>tw1', "<cmd>set textwidth=80<enter>", opts('Set line lenght limit to 80'))
keymap('n', '<leader>tw2', "<cmd>set textwidth=120<enter>", opts('Set line lenght limit to 120'))

-- make saving and quitting more convenient
keymap('n', 'QQ', '<cmd>q<enter>', opts('Close current buffer'))
keymap('n', 'WW', '<cmd>w<enter>', opts('Save current buffer'))

-- make paste use the most recent yank
keymap('n', '<leader>p', '"0p', opts('Paste most recent yank'))
keymap('v', '<leader>p', '"0p', opts('Paste most recent yank'))

-- keep cursor in place when appending lines
keymap('n', 'J', 'mzJ`z', opts('Append line below to current line'))
keymap('n', 'gJ', 'mzgJ`z', opts('Append line below to current line'))

-- use the default half page jump binds but always center them
keymap('n', '<C-d>', '<C-d>zz', opts('Half page jump down'))
keymap('n', '<C-u>', '<C-u>zz', opts('Half page jump up'))

-- keep cursor centered when jumping while searching
keymap('n', 'n', 'nzzzv', opts('Go to next search hit'))
keymap('n', 'N', 'Nzzzv', opts('Go to previous search hit'))

-- Easily hit escape in terminal mode.
keymap('t', '<esc><esc>', '<c-\\><c-n>', opts('Escape the terminal'))

-- -- Open a terminal at the bottom of the screen with a fixed height.
-- keymap('n', '<leader>ot', function()
--   vim.cmd.new()
--   vim.cmd.wincmd 'J'
--   vim.api.nvim_win_set_height(0, 12)
--   vim.wo.winfixheight = true
--   vim.cmd.term()
--   vim.cmd.startinsert()
-- end)

-- Keymap for better default experience
keymap({'n', 'v', 'i'}, '<C-z>', '<nop>', {silent=true})
keymap('n', 'Q', '<nop>', {silent=true})
keymap('n', '<C-j>', '<nop>', {silent=true}) -- move line down, causes conflicts
keymap('n', '<C-f>', '<nop>', {silent=true}) -- page down, use <C-d> instead
keymap('n', '<F1>', '<nop>', {silent=true}) -- would open help, accidental when pressing ESC

-- search and replace macro
--keymap('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts('Search and Replace Macro'))

