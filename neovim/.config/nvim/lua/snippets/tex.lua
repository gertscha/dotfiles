local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local fmta = require("luasnip.extras.fmt").fmta

return {
  s({ trig = "env", snippetType = "snippet", wordTrig = false },
    fmta(
      [[
        \begin{<>}
        <><>
        \end{<>}
      ]],
      {
        i(1),
        t("\t"),
        i(2),
        rep(1),
      })
  ),
}
