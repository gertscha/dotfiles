-- undotree buffer has this type
local opts = { noremap = true, silent = true, buffer = 0 }

vim.keymap.set('n', 'q', vim.cmd.Undotree, opts)
