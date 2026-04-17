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

    ['@string']                             = '@fangcs.string',

    ['@constant']                           = '@fangcs.constant',
    ['@constant.builtin']                   = '@fangcs.constant',
    ['@number']                             = '@fangcs.constant',
    ["@number.float"]                       = "@fangcs.constant",

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

    ["@function"]                           = "@fangcs.declaration",
    ["@function.call"]                      = "@fangcs.base",
    ["@function.method"]                    = "@fangcs.declaration",
    ["@function.method.call"]               = "@fangcs.base",

    -- treesitter highlights in the cmdline (i.e. :)
    ['@keyword.vim']                        = '@fangcs.base',
    ['@punctuation.delimiter.vim']          = '@fangcs.base',


    -- LSP
    ["@lsp.mod.declaration"]                = "@fangcs.declaration",
    ["@lsp.typemod.function.definition"]    = "@fangcs.declaration",
    ["@lsp.type.function"]                  = "@fangcs.base",
    ["@lsp.type.comment"]                   = "@fangcs.comment",
    ["@lsp.type.property"]                  = "@fangcs.base",
    ["@lsp.type.method"]                    = "@fangcs.base",
    ["@lsp.type.generic"]                   = "@fangcs.deemphasize",
    ["@lsp.type.variable"]                  = "@fangcs.variable",
    ["@lsp.type.punct"]                     = "@fangcs.muted",
    ["@lsp.type.operator"]                  = "@fangcs.deemphasize",
    ["@lsp.type.pol"]                       = "@fangcs.deemphasize", -- positional named arguments
  }
  return hl
end

return M
