vim.opt.shortmess:append 'c'

local lspkind = require('lspkind')
lspkind.init {}

local cmp = require('cmp')

local icons = require('settings.icons')

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ['<Tab>'] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ['<C-p>'] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-e>"] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i', 'c' }
    ),
    ['<C-y>'] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { 'i', 'c' }
    ),
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    expandable_indicator = true,
    format = function(entry, vim_item)
      vim_item.kind = icons.kind[vim_item.kind]
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        buffer = '[Buf]',
        path = '[Path]',
      })[entry.source.name]

      return vim_item
    end,
  },
  -- Enable luasnip to handle snippet expansion for nvim-cmp
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

local ls = require 'luasnip'
ls.config.set_config {
  history = false,
  updateevents = 'TextChanged,TextChangedI',
}
