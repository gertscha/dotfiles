return {
  {
    'echasnovski/mini.icons',
    version = '*',
    config = function()
      require('mini.icons').setup()
    end,
  },
  {
    -- Extend and create a/i textobjects
    'echasnovski/mini.ai',
    version = '*',
    config = function()
      require('mini.ai').setup()
    end,
  },
}
