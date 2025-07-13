return {
  -- indent detection
  {
    -- No initialization needed (Vimscript plugin)
    'tpope/vim-sleuth',
    event = 'VeryLazy',
    -- event = { 'BufRead', 'BufNewFile' },
    -- init = {},
  },
  -- session management
  {
    'tpope/vim-obsession',
    cmd = 'Obsession',
    event = { 'BufNewFile', 'BufRead' },
  },
  -- git integration
  {
    'tpope/vim-fugitive',
    cmd = 'Git',
    keys = {
      { '<leader>g', desc = 'Open Git' },
    },
    tag = 'v3.7',
    config = function()
      -- open fugitive, for other bindings see g? when it is open or use :h fugitive
      require('which-key').add({
        mode = 'n', -- NORMAL mode
        silent = true, -- use `silent` when creating keymaps
        noremap = true, -- use `noremap` when creating keymaps
        nowait = false, -- use `nowait` when creating keymaps
        -- Set the buffer height is non-standard because of:
        -- https://github.com/tpope/vim-fugitive/commit/9a4d730270882f9d39a411eb126143eda4d46963
        -- the work around is: https://github.com/tpope/vim-fugitive/issues/1495
        -- open Git and set the split to 50 rows high when opened
        { '<leader>g', '<cmd>50split|0Git<CR>', desc = 'Open Git' },
      })
    end,
  },
  -- smartly create closing pair
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'snacks_picker_input', 'fzf' },
      disable_in_macro = true,
      fast_wrap = {},
    },
  },
  -- LSP setup for Neovim provided Lua functions
  {
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- key press visualization
  {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
      timeout = 0.5,
      maxkeys = 5,
    },
  },
}
