-- Define commands that generate a template file
-- all commands have the 'Tmpl' prefix

--
-- lsp/formatter settings
--
vim.api.nvim_create_user_command('TmplFormatterSetupLua', function(_)
  vim.cmd('edit stylua.toml')
  vim.api.nvim_paste(require('template.content-format')['lua'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplFormatterSetupCpp', function(_)
  vim.cmd('edit .clang-format')
  vim.api.nvim_paste(require('template.content-format')['cpp'], false, -1)
  vim.cmd('write')
end, {})
vim.api.nvim_create_user_command('TmplFormatterSetupCppAlt', function(_)
  vim.cmd('edit .clang-format')
  vim.api.nvim_paste(require('template.content-format')['cppalt'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplFormatterSetupPython', function(_)
  vim.cmd('edit .style.yapf')
  vim.api.nvim_paste(require('template.content-format')['python'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplEditorConfig', function(_)
  vim.cmd('edit .editorconfig')
  vim.api.nvim_paste(require('template.content-format')['editorconfig'], false, -1)
  vim.cmd('write')
end, {})

--
-- quickstart some common files
--
vim.api.nvim_create_user_command('TmplQuickMakefile', function(_)
  vim.cmd('edit Makefile')
  vim.api.nvim_paste(require('template.content-quickstart')['makefile'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplQuickPython', function(_)
  vim.cmd('edit main.py')
  vim.api.nvim_paste(require('template.content-quickstart')['python'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('TmplNvimPluginSpec', function(_)
  vim.api.nvim_paste(require('template.content-quickstart')['nvimpluginspec'], false, -1)
end, {})
