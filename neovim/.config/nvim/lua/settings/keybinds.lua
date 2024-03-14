-- Shorten function name
local keymap = vim.keymap.set

-- little function to set the options
local function opts(desc)
  return { desc = " " .. desc, noremap = true, silent = true }
end

-- set leader key
keymap("", "<Space>", "<Nop>", opts(""))
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
-- keymap('n', '<leader>ea', function() vim.cmd.Lex("%:p:h") end, opts("Open netrw (current file)"))
-- keymap('n', '<leader>e', vim.cmd.Lex, opts("Open netrw (working directory)"))

-- move lines, now using a plugin for this
-- keymap('v', "<A-j>", ":m .+1<CR>==", opts("Move Lines Down"))
-- keymap('v', "<A-k>", ":m .-2<CR>==", opts("Move Lines Up"))
-- keymap("x", "<A-j>", ":m '>+1<CR>gv=gv", opts("Move Lines Down"))
-- keymap("x", "<A-k>", ":m '<-2<CR>gv=gv", opts("Move Lines Up"))

-- alternate command bind
-- keymap('n', "<leader><leader>", ":", opts("Open Commandline"))

-- select all bind
keymap('n', "<leader>ca", "ggVG<cr>", opts("Select all"))

-- redo alternate bind
keymap('n', "<leader>r", "<C-r>", opts("Redo"))

-- Press jj to leave insert mode, convienent but janky
--keymap("i", "jj", "<ESC>", opts("Go to Normal Mode"))

-- Stay in indent mode when moving lines left or right
keymap("v", "<", "<gv", opts("Indent to the left"))
keymap("v", ">", ">gv", opts("Indent to the right"))

-- make saving and quitting more convenient
vim.api.nvim_set_keymap("n", "QQ", ":q<enter>", opts("Close current buffer"))
vim.api.nvim_set_keymap("n", "WW", ":w<enter>", opts("Save current buffer"))

-- make paste use the most recent yank
keymap('n', '<leader>p', '"0p', opts("Paste most recent yank"))
keymap('v', '<leader>p', '"0p', opts("Paste most recent yank"))

-- keep cursor in place when appending lines
keymap('n', 'J', 'mzJ`z', opts("Append line below to current line"))
keymap('n', 'gJ', 'mzgJ`z', opts("Append line below to current line"))

-- use the default half page jump binds but always center them
keymap('n', '<C-d>', '<C-d>zz', opts("Half page jump down"))
  -- not needed since top of page cannot be centered
  -- keymap('n', '<C-u>', '<C-u>zz', opts("Half page jump up"))

-- keep cursor centered when jumping while searching
keymap('n', 'n', 'nzzzv', opts("Go to next search hit"))
keymap('n', 'N', 'Nzzzv', opts("Go to previous search hit"))

-- search and replace macro
--keymap('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts("Search and Replace Macro"))

-- Keymap for better default experience
keymap({'n', 'v', 'i'}, '<C-z>', '<nop>', {silent=true})
keymap('n', 'Q', '<nop>', {silent=true})
keymap('n', '<C-f>', '<nop>', {silent=true}) -- page down, use <C-d> instead
keymap('n', '<F1>', '<nop>', {silent=true}) -- would open help, accidental when pressing ESC

