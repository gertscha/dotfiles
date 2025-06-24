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
    fmta([[if (<>) {]] .. '\n' .. [[<><>]] .. '\n' .. [[}]], { i(1), t('\t'), i(2) })
  ),

  s(
    { trig = 'for', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[for (<> <> = 0; <> << <>; <>++) {]] .. '\n' .. [[<><>]] .. '\n' .. [[}]],
      {
        c(1, {
          i(nil, '...'),
          t('unsigned int'),
          t('size_t'),
          t('int'),
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
    { trig = 'func', snippetType = 'snippet', wordTrig = false },
    fmta([[<> <>(<>) {]] .. '\n' .. [[<><>]] .. '\n' .. [[}]], {
      c(1, { i(nil, '...'), t('void'), t('int'), t('double') }),
      i(2),
      i(3),
      t('\t'),
      i(4),
    })
  ),

  s(
    { trig = 'switch', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[
      switch (<>) {
      <>case <>:
      <><>
      <>break;
      <>default:
      <><>
      }
      ]],
      { i(1), t('\t'), i(2), t('\t\t'), i(3), t('\t\t'), t('\t'), t('\t\t'), i(4) }
    )
  ),

  s(
    { trig = '#', snippetType = 'snippet', wordTrig = false },
    fmta([[#include <<<>>>]], { i(1) })
  ),

  s(
    { trig = 'header', snippetType = 'snippet', wordTrig = false },
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

  s(
    { trig = 'pf', snippetType = 'snippet', wordTrig = false },
    fmta([[printf("\n");]], {})
  ),
}
