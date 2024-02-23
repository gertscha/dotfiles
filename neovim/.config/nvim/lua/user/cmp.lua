-- Code completion
local M = {
  "hrsh7th/nvim-cmp",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "f3fora/cmp-spell",
    "L3mon4d3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    -- "onsails/lspkind.nvim",
    -- "p00f/clangd_extensions.nvim",
    -- "rcarriga/cmp-dap",
  },
}

function M.setup()

  local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
      return false
    end
    local line, col = vim.F.unpack_len(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local icons = require("settings.icons")
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  require("luasnip.loaders.from_vscode").lazy_load()

  local select_opts = { behavior = cmp.SelectBehavior.Select }

  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp", keyword_length = 2 }, -- inform lsp that cmp exists
      { name = "path", keyword_length = 2 },
      { name = "buffer", keyword_length = 2 },
      { name = "luasnip", keyword_length = 2 },
      { name = "nvim_lsp_signature_help", keyword_length = 2 },
      -- { name = "dap", keyword_length = 2 },
      { name = "crates" },
      { name = "nvim_lua" },
    }, {}),
    sorting = {
      priority_weight = 1.0,
      comparators = {
        cmp.config.compare.locality,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        cmp.config.compare.offset,
        cmp.config.compare.order,
        -- cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        -- cmp.config.compare.sort_text,
      },
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    -- formatting = {
    --   format = lspkind.cmp_format({
    --     mode = "symbol_text",
    --     menu = {
    --       buffer = "[Buffer]",
    --       nvim_lsp = "[LSP]",
    --       luasnip = "[LuaSnip]",
    --       nvim_lua = "[Lua]",
    --       latex_symbols = "[Latex]",
    --     },
    --   }),
    -- },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      expandable_indicator = true,
      format = function(entry, vim_item)
        vim_item.kind = icons.kind[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "",
          luasnip = "",
          buffer = "[Buf]",
          path = "",
          emoji = "",
        })[entry.source.name]

        return vim_item
      end,
    },
    mapping = {
      ["<C-s>"] = cmp.mapping({ i = cmp.mapping.complete({ reason = cmp.ContextReason.Manual }) }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item(select_opts)
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item(select_opts)
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      -- ["<C-r>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }), -- For some reason this mapping seems to mess with the <Tab> mapping ?!
      ["<C-i>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
      ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),
      ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
      ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
      -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false
    },
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  -- cmp.setup.cmdline({ "/", "?" }, {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = {
  --     { name = "buffer" },
  --   },
  -- })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

return M

