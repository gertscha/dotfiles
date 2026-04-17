local M = {}

---@param t FangColorScheme
---@return table
function M.get(t)
  -- stylua: ignore
  local hl = {
    -- ['@markup']                             = {},
    ['@markup.strong']                      = { fg = t.base.fgc, bold = true },
    ['@markup.italic']                      = { fg = t.base.fgc, italic = true },
    ['@markup.strikethrough']               = { fg = t.base.fgc, strikethrough = true },
    ['@markup.underline']                   = { fg = t.base.fgc, underline = true },
    ['@markup.heading']                     = { fg = t.base.primary, bg = t.bgc_hi, bold = true },
    ['@markup.raw']                         = { fg = t.base.fgc, bg = t.bgc_hi },
    ['@markup.link']                        = { fg = t.base.secondary },
    ["@markup.link.label"]                  = { fg = t.base.secondary },
    ["@markup.link.url"]                    = { italic = true },
    ["@markup.quote"]                       = { fg = t.base.fgc, italic = true },
    ["@markup.list"]                        = { fg = t.deemphasize },

    -- render markdown plugin
    ['RenderMarkdownQuote']                 = { fg = t.base.secondary, italic = true },
    ['RenderMarkdownBullet']                = { fg = t.deemphasize },
    ['RenderMarkdownLink']                  = { fg = t.base.secondary },
    ['RenderMarkdownLinkTitle']             = { fg = t.base.secondary },
    ['RenderMarkdownWikiLink']              = { fg = t.base.secondary, italic = true },
    ['RenderMarkdownTodo']                  = { fg = t.base.muted, bold = true },
    ['RenderMarkdownUnchecked']             = { fg = t.base.fgc, bold = true },
    ['RenderMarkdownChecked']               = { fg = t.base.muted },
    ['RenderMarkdownTableHead']             = { fg = t.base.primary },
    ['RenderMarkdownTableRow']              = { fg = t.base.fgc },
    ['RenderMarkdownSuccess']               = { fg = t.base.green },
    ['RenderMarkdownWarn']                  = { fg = t.base.yellow },

    ['RenderMarkdownCodeInline']            = { fg = t.base.fgc, bg = t.bgc_hi },
    ['RenderMarkdownCode']                  = { fg = t.base.fgc, bg = t.bgc_hi },
    ['RenderMarkdownCodeBorder']            = { fg = t.bgc_hi_bright },

    ['RenderMarkdownH1']                    = { fg = t.base.bgc, bg = t.muted_bgc, bold = true },
    ['RenderMarkdownH2']                    = { fg = t.base.bgc, bold = true },
    ['RenderMarkdownH3']                    = { fg = t.base.fgc, bold = true },
    ['RenderMarkdownH4']                    = { fg = t.base.fgc, bold = true },
    ['RenderMarkdownH5']                    = { fg = t.base.fgc, bold = true },
    ['RenderMarkdownH6']                    = { fg = t.base.fgc, bold = true },
    ['RenderMarkdownH1Bg']                  = { fg = t.base.bgc, bg = t.primary_bgc },
    ['RenderMarkdownH2Bg']                  = { fg = t.base.bgc, bg = t.green_bgc },
    ['RenderMarkdownH3Bg']                  = { fg = t.base.fgc, bg = t.bgc_hi_bright },
    ['RenderMarkdownH4Bg']                  = { fg = t.base.fgc, bg = t.bgc_hi_bright },
    ['RenderMarkdownH5Bg']                  = { fg = t.base.fgc, bg = t.bgc_hi_bright },
    ['RenderMarkdownH6Bg']                  = { fg = t.base.fgc, bg = t.bgc_hi_bright },
  }
  return hl
end

return M
