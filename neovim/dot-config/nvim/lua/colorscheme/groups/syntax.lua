local M = {}

---@param t FangColorScheme
---@return table
function M.get(t)
  -- stylua: ignore
  local hl = {
    -- Syntax based
    Delimiter                               = '@fangcs.muted',
    SpecialChar                             = '@fangcs.muted',
    Operator                                = '@fangcs.deemphasize',

    Added                                   = '@fangcs.diff.added',
    Removed                                 = '@fangcs.diff.removed',
    Changed                                 = '@fangcs.diff.changed',
    DiffAdd                                 = '@fangcs.diff.added',
    DiffDelete                              = '@fangcs.diff.removed',
    DiffChange                              = '@fangcs.diff.changed',
    DiffText                                = '@fangcs.highlight',
    DiffFile                                = '@fangcs.changed',
    DiffIndexLine                           = '@fangcs.changed',

    DiagnosticOk                            = { fg = t.base.green },
    DiagnosticInfo                          = { fg = t.information },
    DiagnosticWarn                          = { fg = t.warning },
    DiagnosticError                         = { fg = t.error },
    DiagnosticHint                          = { fg = t.hint },
    DiagnosticUnnecessary                   = { fg = t.hint },
    DiagnosticUnderlineError                = { sp = t.error        , underdotted = true },
    DiagnosticUnderlineHint                 = { sp = t.hint         , underdotted = true },
    DiagnosticUnderlineInfo                 = { sp = t.information  , underdotted = true },
    DiagnosticUnderlineOk                   = { sp = t.base.green   , underdotted = true },
    DiagnosticUnderlineWarn                 = { sp = t.base.yellow  , underdotted = true },
    DiagnosticVirtualTextError              = { fg = t.error },
    DiagnosticVirtualTextHint               = { fg = t.hint },
    DiagnosticVirtualTextInfo               = { fg = t.information  },
    DiagnosticVirtualTextOk                 = { fg = t.base.green },
    DiagnosticVirtualTextWarn               = { fg = t.warning  },

    healthError                             = { fg = t.error },
    healthSuccess                           = { fg = t.base.green },
    healthWarning                           = { fg = t.warning },

    Comment                                 = '@fangcs.comment',
    Keyword                                 = '@fangcs.muted',
    Title                                   = { fg = t.base.primary },

    String                                  = '@fangcs.string',
    Boolean                                 = '@fangcs.constant',
    Number                                  = '@fangcs.constant',

    Function                                = '@fangcs.base',
    Type                                    = '@fangcs.base',
    PreProc                                 = '@fangcs.base',
    Identifier                              = '@fangcs.base',
    Constant                                = '@fangcs.base',
    Character                               = '@fangcs.base',
    Special                                 = '@fangcs.base',
    Underlined                              = '@fangcs.base',
    Conditional                             = '@fangcs.base',
    Define                                  = '@fangcs.base',
    Error                                   = '@fangcs.base',
    Exception                               = '@fangcs.base',
    Float                                   = '@fangcs.base',
    Include                                 = '@fangcs.base',
    Label                                   = '@fangcs.base',
    Macro                                   = '@fangcs.base',
    PreCondit                               = '@fangcs.base',
    Repeat                                  = '@fangcs.base',
    SpecialComment                          = '@fangcs.base',
    Statement                               = '@fangcs.base',
    StorageClass                            = '@fangcs.base',
    Structure                               = '@fangcs.base',
    Tag                                     = '@fangcs.base',
    Todo                                    = '@fangcs.base',
    Typedef                                 = '@fangcs.base',
  }
  return hl
end

return M
