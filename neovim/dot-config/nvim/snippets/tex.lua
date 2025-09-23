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
    { trig = 'ttt', snippetType = 'snippet', wordTrig = false },
    fmta([[\texttt{<>}]], { i(1) })
  ),
  s(
    { trig = 'tbf', snippetType = 'snippet', wordTrig = false },
    fmta([[\textbf{<>}]], { i(1) })
  ),
  s(
    { trig = 'tit', snippetType = 'snippet', wordTrig = false },
    fmta([[\textit{<>}]], { i(1) })
  ),
  s(
    { trig = 'cit', snippetType = 'snippet', wordTrig = false },
    fmta([[\cite{<>}]], { i(1) })
  ),
}
