-- Code completion
local M = {
  'hrsh7th/nvim-cmp',
  lazy = false,
  priority = 100,
  dependencies = {
    'onsails/lspkind.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    'f3fora/cmp-spell',
    'L3mon4d3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    -- 'rafamadriz/friendly-snippets',
    -- 'p00f/clangd_extensions.nvim',
    -- 'rcarriga/cmp-dap',
  },
}

function M.config()
  require 'plugins.configuration.completion_settings'
end

return M

