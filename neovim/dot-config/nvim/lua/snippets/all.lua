local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s('date', t(os.date('%d.%m.%Y'))),
  s('gh', t('github.com/gertscha')),
}
