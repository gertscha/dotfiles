-- Define commands that generate a template file
-- all commands have the 'Tmpl' prefix


-- lsp/formatter settings
local format_defs = require('template.content-formatters')

vim.api.nvim_create_user_command('TmplFormatterSetupLua', function(_)
  vim.cmd('edit stylua.toml')
  vim.api.nvim_paste(format_defs['lua'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplFormatterSetupCpp', function(_)
  vim.cmd('edit .clang-format')
  vim.api.nvim_paste(format_defs['cpp'], false, -1)
  vim.cmd('write')
end, {})
vim.api.nvim_create_user_command('TmplFormatterSetupCppAlt', function(_)
  vim.cmd('edit .clang-format')
  vim.api.nvim_paste(format_defs['cppalt'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplFormatterSetupPython', function(_)
  vim.cmd('edit .style.yapf')
  vim.api.nvim_paste(format_defs['python'], false, -1)
  vim.cmd('write')
end, {})


-- quickstart some common files
local quick_defs = require('template.content-quickstart')

vim.api.nvim_create_user_command('TmplQuickMakefile', function(_)
  vim.cmd('edit Makefile')
  vim.api.nvim_paste(quick_defs['makefile'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplQuickPython', function(_)
  vim.cmd('edit main.py')
  vim.api.nvim_paste(quick_defs['python'], false, -1)
  vim.cmd('write')
end, {})
