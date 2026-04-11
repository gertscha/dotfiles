local opts = { noremap = true, silent = true, buffer = 0 }

vim.keymap.set('n', '<A-q>', '<cmd>close<CR>', opts)
vim.keymap.set('n', '<esc>', '<cmd>close<CR>', opts)
