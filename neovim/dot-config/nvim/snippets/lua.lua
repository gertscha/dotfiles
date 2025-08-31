---@diagnostic disable: undefined-global

return {
  s(
    { trig = 'if', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[if <> then]] .. '\n' .. [[<><>]] .. '\n' .. [[end]],
      { i(1), t('\t'), i(2) }
    )
  ),
  s(
    { trig = 'notify', snippetType = 'snippet', wordTrig = false },
    fmta(
      [[vim.notify('<>', vim.log.levels.<>)]],
      {
        i(1),
        c(2, {
          t('INFO'),
          t('WARN'),
          t('ERROR'),
          i(nil, ''),
        }),
      }
    )
  ),
}
