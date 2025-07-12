return {
  {
    'echasnovski/mini.icons',
    version = '*',
    config = true,
  },
  {
    -- Extend and create a/i textobjects
    'echasnovski/mini.ai',
    version = '*',
    event = { 'BufRead', 'BufNewFile' },
    opts = {
      mappings = {
        around = 'a',
        inside = 'i',
        -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
        -- Map LSP selection manually to use it (see `:h MiniAi.config`)
        around_next = 'an',
        inside_next = 'in',
        around_last = 'al',
        inside_last = 'il',
        -- Move cursor to corresponding edge of `a` textobject
        goto_left = 'g[',
        goto_right = 'g]',
      },
    },
  },
  {
    -- modify surrounding objects like quotes
    'echasnovski/mini.surround',
    version = '*',
    event = { 'BufRead', 'BufNewFile' },
    opts = {
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`
        suffix_last = 'l', -- Suffix to search with "prev" method
        suffix_next = 'n', -- Suffix to search with "next" method
      },
    },
  },
}
