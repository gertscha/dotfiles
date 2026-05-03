local M = {}

---@param t FangColorScheme
---@return table
function M.get(t)
  -- stylua: ignore
  local hl = {
    FzfLuaBackdrop                          = { bg = t.base.bgc },

    FzfLuaScrollbar                         = { fg = t.base.secondary },
    FzfLuaFzfScrollbar                      = { fg = t.base.secondary },
  }
  return hl
end

return M
