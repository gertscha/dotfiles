local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local sn = ls.snippet_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local events = require('luasnip.util.events')
local extras = require('luasnip.extras')
local rep = extras.rep
local fmta = require('luasnip.extras.fmt').fmta

-- require("luasnip.session.snippet_collection").clear_snippets "c"

local function header_guard()
  local filename = vim.fn.expand('%:t')
  local guard = string.upper(filename:gsub('%.', '_'):gsub('-', '_') .. '_')
  return guard
end

return {
  s(
    { trig = 'if', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[if (<>) {]] .. '\n' .. [[<><>]] .. '\n' .. [[}]],
      { i(1), t('\t'), i(2) }
    )
  ),
  s(
    { trig = 'for', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[for (<> <> = 0; <> << <>; <>++) {]] .. '\n' .. [[<><>]] .. '\n' .. [[}]],
      {
        c(1, {
          t('[type]'),
          t('unsigned int'),
          t('int'),
          t('size_t'),
          i(nil, '...'),
        }),
        i(2),
        rep(2),
        i(3),
        rep(2),
        t('\t'),
        i(4),
      }
    )
  ),
  s(
    { trig = 'header' },
    fmta(
      [[
    #ifndef <guard>
    #define <guard>

    <ins>

    #endif // <guard>
    ]],
      {
        guard = f(header_guard),
        ins = i(1),
      }
    )
  ),
}
