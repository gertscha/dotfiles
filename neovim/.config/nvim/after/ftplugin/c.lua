-- For delimitMate
local vscript = 'let b:delimitMate_matchpairs = "(:),[:],{:}"'
vim.api.nvim_command(vscript)

vim.opt.commentstring = "// %s"
