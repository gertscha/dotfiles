return {
  -- indent detection
  {
    -- No initialization needed (Vimscript plugin)
    'tpope/vim-sleuth',
    event = 'User my.lazy.trigger',
    -- init = {},
  },
  -- session management
  {
    'tpope/vim-obsession',
    cmd = 'Obsession',
    event = 'User my.lazy.trigger',
  },
  -- git integration
  {
    'tpope/vim-fugitive',
    tag = 'v3.7',
    event = 'VeryLazy',
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
        { '<leader>g', '<cmd>50split|0Git<cr>', desc = 'Open Git' },
        { '<leader>rd', '<cmd>Gdiff<cr>', desc = 'open git diff view' },
        { '<leader>rm', '<cmd>Git mergetool<cr>', desc = 'open git merge tool' },
        { '<leader>rB', '<cmd>Git blame --date=human<cr>', desc = 'git blame (file)' },
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
