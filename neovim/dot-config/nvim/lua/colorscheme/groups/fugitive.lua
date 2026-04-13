local M = {}

---@param t FangColorScheme
---@return table
function M.get(t)
  -- stylua: ignore
  local hl = {
    fugitiveUntrackedSection                 = '@fangcs.base',
    fugitiveUntrackedModifier                = { fg = t.base.red },
    fugitiveUnstagedSection                  = '@fangcs.base',
    fugitiveUnstagedModifier                 = { fg = t.base.yellow },
    fugitiveStagedSection                    = '@fangcs.base',
    fugitiveStagedModifier                   = { fg = t.base.green },
    fugitiveHeader                           = { fg = t.base.primary },
    fugitiveHeading                          = { fg = t.base.fgc, bold = true },
    fugitiveUntrackedHeading                 = { fg = t.base.fgc, bold = true },
    fugitiveUnstagedHeading                  = { fg = t.base.fgc, bold = true },
    fugitiveSymbolicRef                      = { fg = t.base.secondary },
    fugitiveHash                             = { fg = t.base.primary },
    fugitiveCount                            = { fg = t.base.secondary },

    gitcommitSummary                         = { fg = t.base.primary },
  }
  return hl
end

return M
