-- For delimitMate
local vscript = 'let b:delimitMate_matchpairs = "(:),[:],{:}"'
vim.api.nvim_command(vscript)

vim.opt.commentstring = "// %s"

vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
