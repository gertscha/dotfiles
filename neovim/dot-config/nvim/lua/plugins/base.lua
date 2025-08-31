---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'echasnovski/mini.icons', { version = 'stable' })
    Add_plugin(spec, 'folke/which-key.nvim', { version = 'stable' })
    Add_plugin(spec, 'mbbill/undotree', nil)
    Add_plugin(spec, 'tpope/vim-sleuth', nil)
    Add_plugin(spec, 'tpope/vim-obsession', nil)
    Add_plugin(spec, 'tpope/vim-fugitive', { version = 'v3.7' })
    Add_plugin(spec, 'stevearc/oil.nvim', { version = 'bbad9a7' })
    Add_plugin(spec, 'windwp/nvim-autopairs', { version = '23320e7' })
    Add_plugin(spec, 'nvzone/showkeys', nil)
  end,
}

-- is evaluated eagerly
function M.config()
  -- icon provider, dependency for many plugins
  require('mini.icons').setup()

  local whichkey = require('which-key')
  whichkey.setup({})
  whichkey.add({
    mode = 'n', -- NORMAL mode
    { 'gr', group = 'diagnostics' },
    { '<space>s', group = 'Search' },
    { '<space>l', group = 'Session Management' },
    { '<space>o', group = 'Open Screens' },
    { '<space>om', group = 'Markdown' },
    { '<space>t', group = 'Toggle' },
    { '<space>r', group = 'Git tools' },
    { '<space>tw', group = 'Line width settings' },
    { '<space>ts', group = 'Command line visibility toggle' },
    { '<leader>d', group = 'diagnostics' },
    { '<leader>dc', group = '[c]all hierarchy' },
    { '<leader>dr', group = 'Restart/Reset LSP functionality' },
    { '<leader>dg', group = 'default LSP g binds' },
    { '<leader>dgr', group = 'default LSP gr binds' },
  })

  -- git integration with fugitive
  -- open fugitive, for other bindings see g? when it is open or use :h fugitive
  whichkey.add({
    mode = 'n', -- NORMAL mode
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps

    -- Setting the buffer height is non-standard because of:
    -- https://github.com/tpope/vim-fugitive/commit/9a4d730270882f9d39a411eb126143eda4d46963
    -- the work around is: https://github.com/tpope/vim-fugitive/issues/1495
    -- open Git and set the split to 70 rows high when opened
    -- { '<leader>g', '<cmd>70split|0Git<cr>', desc = 'Open Git' },

    -- instead we use :only / <C-w>o to maximize the buffer
    { '<leader>g', '<cmd>Git|only<cr>', desc = 'Open Git' },
    { '<leader>rd', '<cmd>Gdiff<cr>', desc = 'open git diff view' },
    { '<leader>rm', '<cmd>Git mergetool<cr>', desc = 'open git merge tool' },
    { '<leader>rB', '<cmd>Git blame --date=human<cr>', desc = 'git blame (file)' },
  })

  -- undo tree plugin
  -- change default width of the undotree buffer width
  vim.g.undotree_SplitWidth = 50
  -- set the focus to the undotree buffer
  vim.g.undotree_ShortIndicators = 1
  vim.g.undotree_SetFocusWhenToggle = 1
  vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {
    desc = 'Open Undotree',
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
  })

  -- smartly create closing pair
  require('nvim-autopairs').setup({
    disable_filetype = { 'snacks_picker_input', 'fzf' },
    disable_in_macro = true,
    fast_wrap = {},
  })

  -- file navigation
  require('oil').setup({
    default_file_explorer = true,
    columns = { 'icon' },
    delete_to_trash = true,
    view_options = {
      show_hidden = false, -- can be toggled with 'g.' keybind
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        if name ~= '.config' then
          local m = name:match('^%.')
          return m ~= nil
        else
          return false
        end
      end,
    },
    float = {
      padding = 5,
      max_width = 100,
      -- Split direction: "auto", "left", "right", "above", "below".
      preview_split = 'below',
    },
    use_default_keymaps = false,
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_vsplit',
      ['<C-h>'] = 'actions.select_split',
      -- ['<C-t>'] = 'actions.select_tab',
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['q'] = 'actions.close',
      ['<C-l>'] = 'actions.refresh',
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      -- ['`'] = 'actions.cd', -- does not seem to work
      -- ['~'] = 'actions.tcd', -- tab :cd I think
      ['gs'] = 'actions.change_sort',
      -- ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      -- ['g\\'] = 'actions.toggle_trash',
    },
  })
  vim.keymap.set(
    'n',
    '-',
    '<cmd>Oil --float<CR>',
    { desc = 'Oil: parent dir', silent = true, noremap = true }
  )

  -- key press visualization
  require('showkeys').setup({
    timeout = 0.5,
    maxkeys = 6,
  })
end

return M
