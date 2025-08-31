---@diagnostic disable: undefined-global

return {
  s(
    { trig = 'env', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[
        \begin{<>}
        <><>
        \end{<>}
      ]],
      {
        i(1),
        t('\t'),
        i(2),
        rep(1),
      }
    )
  ),
  s(
    { trig = 'tt', snippetType = 'snippet', wordTrig = false },
    fmta([[\texttt{<>}]], { i(1) })
  ),
  s(
    { trig = 'bf', snippetType = 'snippet', wordTrig = false },
    fmta([[\textbf{<>}]], { i(1) })
  ),
  s(
    { trig = 'it', snippetType = 'snippet', wordTrig = false },
    fmta([[\textit{<>}]], { i(1) })
  ),
}
