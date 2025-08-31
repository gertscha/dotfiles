-- disable autoindent for tex files, since it does not work properly
vim.opt_local.autoindent = false
vim.opt_local.smartindent = false
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

vim.cmd('setlocal spell')
vim.cmd('setlocal spelllang=en_us')
