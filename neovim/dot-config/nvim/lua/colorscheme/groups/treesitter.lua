local M = {}

---@param t FangColorScheme
---@return table
function M.get(t)
  -- stylua: ignore
  local hl = {
    -- Treesitter based
    ['@variable']                           = '@fangcs.variable',
    ['@variable.parameter']                 = '@fangcs.base',
    ['@variable.builtin']                   = '@fangcs.base',
    ['@variable.member']                    = '@fangcs.deemphasize',
    ['@property']                           = '@fangcs.base',
    ['@field']                              = '@fangcs.base',
    ['@constant']                           = '@fangcs.base',

    ['@string']                             = '@fangcs.string',
    ['@number']                             = '@fangcs.constant',

    ['@keyword']                            = '@fangcs.muted',
    ['@keyword.return']                     = '@fangcs.kw-return',
    ['@keyword.repeat']                     = '@fangcs.control-flow',
    ['@keyword.conditional']                = '@fangcs.control-flow',
    ['@punctuation.delimiter']              = '@fangcs.muted',
    ['@punctuation.special']                = '@fangcs.muted',
    ['@punctuation.bracket']                = '@fangcs.muted',
    ['@module']                             = '@fangcs.muted',

    ['@type']                               = '@fangcs.deemphasize',
    ['@type.builtin']                       = '@fangcs.deemphasize',

    -- treesitter highlights in the cmdline (i.e. :)
    ['@keyword.vim']                        = '@fangcs.base',
    ['@punctuation.delimiter.vim']          = '@fangcs.base',


    -- LSP
    ["@lsp.mod.declaration"]                = "@fangcs.declaration",
    ["@lsp.typemod.function.definition"]    = "@fangcs.declaration",
    ["@function"]                           = "@fangcs.declaration",
    ["@function.call"]                      = "@fangcs.base",
    ["@function.method"]                    = "@fangcs.declaration",
    ["@function.method.call"]               = "@fangcs.base",
    ["@lsp.type.comment"]                   = "@fangcs.comment",
    ["@lsp.type.function"]                  = "@fangcs.base",
    ["@lsp.type.generic"]                   = "@fangc.deemphasize",
    ["@lsp.type.variable"]                  = "@fangcs.variable",
  }
  return hl
end

return M
