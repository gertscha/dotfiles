local M = {
  'Raimondi/delimitMate',
  event = 'InsertEnter',
}

function M.config()
  vim.g.delimitMate_autoclose = 1
  vim.g.delimitMate_expand_cr = 1
  vim.g.delimitMate_matchpairs = '(:),[:],{:}'
  vim.g.delimitMate_quotes = '" \' `'
end

return M
