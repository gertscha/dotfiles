-- snacks history float has this type
-- default closes with q, add esc as second option
local opts = { noremap = true, silent = true, buffer = 0 }

vim.keymap.set('n', '<esc>', ':close<CR>', opts)
