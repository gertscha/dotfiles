-- Shorten function name
local keymap = vim.keymap.set

-- set leader key
keymap('', '<Space>', '<Nop>', {})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

---@param desc string
---@return table
local function opts(desc)
  return { desc = desc, noremap = true, silent = true }
end

-- Highlighting toggles
keymap('n', '<leader>tlc', '<cmd>se cuc!<cr>', opts('Show Column Hi'))
keymap('n', '<leader>tll', '<cmd>se cul!<cr>', opts('Show Line Hi'))
-- toggle line length indicator, cc ~= colorcolumn
keymap(
  'n',
  '<leader>th',
  "<cmd>let &cc = &cc == '' ? '80,120' : ''<enter>",
  opts('Toggle line length limit highlighting')
)

keymap('n', '<leader>tsc', function()
  local val = vim.api.nvim_get_option_value('cmdheight', {})
  if val == 0 then
    vim.o.cmdheight = 1
  else
    vim.o.cmdheight = 0
  end
end, opts('Toggle command line visibility'))

keymap('n', '<leader>twl', '<cmd>set wrap!<enter>', opts('Toggle line wrap'))
keymap(
  'n',
  '<leader>tw0',
  '<cmd>set textwidth=0<enter>',
  opts('Disable line length limit')
)
keymap(
  'n',
  '<leader>tw1',
  '<cmd>set textwidth=80<enter>',
  opts('Set line length limit to 80')
)
keymap(
  'n',
  '<leader>tw2',
  '<cmd>set textwidth=120<enter>',
  opts('Set line length limit to 120')
)

keymap('n', '<leader>p', '"0p', opts('Paste most recent yank'))
keymap('v', '<leader>p', '"0p', opts('Paste most recent yank'))

keymap('n', 'ga', 'ggVG<cr>', opts('Select all')) -- select all bind
keymap('n', 'gA', '<cmd>ascii<cr>', opts('Character info')) -- rebind default ga
keymap('n', 'gy', '<cmd>%y<cr>', opts('Yank Select all'))
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>') --

-- Stay in indent mode when moving lines left or right
keymap('v', '<', '<gv', opts('Indent to the left'))
keymap('v', '>', '>gv', opts('Indent to the right'))
-- keep cursor in place when appending lines
keymap('n', 'J', 'mzJ`z', opts('Append line below to current line'))
keymap('n', 'gJ', 'mzgJ`z', opts('Append line below to current line'))
keymap('n', 'x', '"9x', opts('Cut')) -- make cut not overwrite the paste register
-- use the default half page jump binds but always center them
keymap('n', '<C-d>', '<C-d>zz', opts('Half page jump down'))
keymap('n', '<C-u>', '<C-u>zz', opts('Half page jump up'))
-- keep cursor centered when jumping while searching (and open folds)
keymap('n', 'n', 'nzzzv', opts('Go to next search hit'))
keymap('n', 'N', 'Nzzzv', opts('Go to previous search hit'))

-- move lines around
keymap('n', '<A-j>', '<cmd>m .+1<CR>==', opts('Move current line down'))
keymap('n', '<A-k>', '<cmd>m .-2<CR>==', opts('Move current line up'))
keymap('i', '<A-j>', '<esc><cmd>m .+1<CR>==gi', opts('Move current line down'))
keymap('i', '<A-k>', '<esc><cmd>m .-2<CR>==gi', opts('Move current line up'))
keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", opts('Move current line down'))
keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", opts('Move current line down'))

-- Easily hit escape in terminal mode.
keymap('t', '<esc>', '<c-\\><c-n>', opts('Escape the terminal'))

-- open/close quickfix list, navigate with '[q' and ']q'
keymap('n', '<M-w>', '<cmd>copen<cr>', opts('Open Quickfix list'))
keymap('n', '<M-q>', '<cmd>cclose<cr>', opts('Close Quickfix list'))

-- run the current line in lua (nice when configuring neovim)
keymap('n', '<leader>x', '<cmd>.lua<cr>', opts('Run current line (Lua)'))

-- session management
keymap('n', '<leader>lt', function()
  vim.cmd('Obsession')
end, opts('Toggle Auto-recording of Session'))
keymap('n', '<leader>ldd', function()
  vim.cmd('Obsession!')
end, opts('Stop Auto-recording of Session and delete session file'))
local my_session = 'Session-manual.vim'
keymap(
  'n',
  '<leader>lg',
  '<cmd>source ' .. my_session .. '<cr>',
  opts('Load manual Session')
)
keymap(
  'n',
  '<leader>ls',
  '<cmd>mksession! ' .. my_session .. '<cr>',
  opts('Save manual Session')
)

-- copy diagnostics from the current line
keymap('n', 'yd', function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line_num = pos[1] - 1 -- 0-indexed
  local diagnostics = vim.diagnostic.get(0, { lnum = line_num })
  if #diagnostics == 0 then
    vim.notify('No diagnostic found on this line', vim.log.levels.WARN)
    return
  end
  local message_lines = {}
  for _, d in ipairs(diagnostics) do
    for msg_line in d.message:gmatch('[^\n]+') do
      table.insert(message_lines, msg_line)
    end
  end
  local formatted = {}
  table.insert(formatted, table.concat(message_lines, '\n'))
  vim.fn.setreg('+', table.concat(formatted, '\n\n'))
end, { desc = 'Yank diagnostic on current line' })

-- -- Open a terminal at the bottom of the screen with a fixed height.
-- keymap('n', '<leader>ot', function()
--   vim.cmd.new()
--   vim.cmd.term()
--   vim.cmd.wincmd('J')
--   vim.api.nvim_win_set_height(0, 12)
--   vim.cmd.startinsert()
-- end)

-- Keymap for better default experience
keymap({ 'n', 'v', 'i' }, '<C-z>', '<nop>', { silent = true })
keymap('n', 'Q', '<nop>', { silent = true })
keymap('n', '<C-j>', '<nop>', { silent = true }) -- navigate line down, conflicts
keymap('n', '<C-f>', '<nop>', { silent = true }) -- page down, use <C-d> instead
keymap('n', '<C-b>', '<nop>', { silent = true }) -- page up, use <C-u> instead
keymap('n', '<F1>', '<nop>', { silent = true }) -- open help, accidental presses

-- change default bindings for LSP, all of these have better alternatives using fzf
-- but to keep them as fallback they are rebound
local remapopts = { noremap = true, silent = true }
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gO')
vim.keymap.set('n', '<leader>dgO', 'vim.lsp.buf.document_symbol()', remapopts)
vim.keymap.set('n', '<leader>dgri', 'vim.lsp.buf.implementation()', remapopts)
vim.keymap.set('n', '<leader>dgra', 'vim.lsp.buf.code_actions()', remapopts)
vim.keymap.set('n', '<leader>dgrr', 'vim.lsp.buf.references()', remapopts)
vim.keymap.set('n', '<leader>dgrn', 'vim.lsp.buf.rename()', remapopts)
