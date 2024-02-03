local M = {
  "SmiteshP/nvim-navic",
  event = { "BufRead", "BufNewFile" },
  dependencies = {
    "neovim/nvim-lspconfig",
    {
      -- actually this depends on navic
      -- but it has no config they are swapped
      "LunarVim/breadcrumbs.nvim",
      opts = {},
    },
  },
}

function M.config()
  local icons = require "settings.icons"
  require("nvim-navic").setup {
    icons = icons.kind,
    highlight = true,
    lsp = {
      auto_attach = true,
    },
    click = true,
    separator = " " .. icons.ui.ChevronRight .. " ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  }
end

return M

