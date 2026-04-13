local M = {}

---@param t FangColorScheme
---@return table
function M.load_groups(t)

  -- Base Highlight Groups
  -- stylua: ignore
  local base_hi = {
    ['@fangcs.base']                        = { fg = t.base.fgc },
    ['@fangcs.deemphasize']                 = { fg = t.deemphasize },
    ['@fangcs.muted']                       = { fg = t.base.muted },
    ['@fangcs.comment']                     = { fg = t.base.comment },
    ['@fangcs.declaration']                 = { fg = t.base.primary },
    ['@fangcs.constant']                    = { fg = t.base.primary },
    ['@fangcs.kw-return']                   = { fg = t.base.primary },
    ['@fangcs.variable']                    = { fg = t.base.fgc },
    ['@fangcs.control-flow']                = { fg = t.base.secondary },
    ['@fangcs.string']                      = { fg = t.deemphasize, italic = true },
    ['@fangcs.search']                      = { fg = t.base.bgc, bg = t.secondary_bgc },
    ['@fangcs.highlight']                   = { fg = t.base.fgc, bg = t.bgc_hi_bright },

    ['@fangcs.diff.added']                  = { fg = t.base.green },
    ['@fangcs.diff.removed']                = { fg = t.base.red },
    ['@fangcs.diff.changed']                = { fg = t.base.yellow },
  }

  ---@param group string
  local function init(group)
    return require('colorscheme.groups.' .. group).get(t)
  end
  return {
    base_hi,
    editor = init('editor'),
    syntax = init('syntax'),
    treesitter = init('treesitter'),
    fugitive = init('fugitive'),
    markup = init('markup'),
  }
end

return M
