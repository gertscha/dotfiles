local M = {
  'stevearc/oil.nvim',
  dependencies = {
    { "echasnovski/mini.icons", opts = {} }
  },
  tag = 'stable',
  cmd = 'Oil',
  keys = { '-', desc = 'Open Oil FS' },
}

function M.config()
  require('oil').setup {
    default_file_explorer = true,
    columns = {
      'icon',
      -- 'size',
      -- 'permissions',
      -- 'mtime',
    },
    delete_to_trash = true,
    view_options = {
      show_hidden = false, -- can be toggled with 'g.' keybind
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        if name ~= '.config' then
          local m = name:match("^%.")
          return m ~= nil
        else
          return false
        end
      end,
    },
    float = {
      padding = 5,
      max_width = 80,
    },
    use_default_keymaps = false,
    keymaps = {
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-s>'] = 'actions.select_vsplit',
      ['<C-h>'] = 'actions.select_split',
      -- ['<C-t>'] = 'actions.select_tab',
      -- ['<C-p>'] = 'actions.preview', -- does not work for float
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
  }

  require('which-key').add({
    mode = 'n',     -- NORMAL mode
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '-', '<cmd>Oil --float<CR>', desc = 'Oil: parent dir' },
  })
end

return M
