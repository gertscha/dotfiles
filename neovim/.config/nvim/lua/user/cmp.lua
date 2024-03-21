-- Code completion
local M = {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
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

  luasnip.config.setup {}
  -- require("luasnip.loaders.from_vscode").lazy_load()

  local select_opts = { behavior = cmp.SelectBehavior.Select }


  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    completion = { completeopt = 'menu,menuone,noselect' },
    sources = {
      { name = "nvim_lsp" }, -- inform lsp that cmp exists
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer", keyword_length = 2 },
      { name = "nvim_lsp_signature_help", keyword_length = 2 },
      -- { name = "dap", keyword_length = 2 },
      -- { name = "crates" },
      { name = "nvim_lua" },
    },
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
    mapping = cmp.mapping.preset.insert {
      -- Select the [n]ext item
      ['<C-n>'] = cmp.mapping.select_next_item(),
      -- Select the [p]revious item
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ["<C-e>"] = cmp.mapping.abort(),

      -- Accept ([y]es) the completion.
      --  This will auto-import if your LSP supports it.
      --  This will expand snippets if the LSP sent a snippet.
      ['<C-y>'] = cmp.mapping.confirm { select = true },
      ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Insert }),

      -- Manually trigger a completion from nvim-cmp.
      --  Generally you don't need this, because nvim-cmp will display
      --  completions whenever it has completion options available.
      ['<C-Space>'] = cmp.mapping.complete {},

      -- Think of <c-l> as moving to the right of your snippet expansion.
      --  So if you have a snippet that's like:
      --  function $name($args)
      --    $body
      --  end
      --
      -- <c-l> will move you to the right of each of the expansion locations.
      -- <c-h> is similar, except moving you backwards.
      ['<C-l>'] = cmp.mapping(function()
        if luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { 'i', 's' }),
      ['<C-h>'] = cmp.mapping(function()
        if luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        end
      end, { 'i', 's' }),
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

