if not Telescope_fallback then
  return {}
else
  return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = 'Telescope',
    keys = { '<leader>s', desc = 'Telescope' },
    config = function()
      -- which-key setup (make sure it matches the load keys)
      require('which-key').add({
        -- make sure this matches the keys entry for the plugin loading
        {
          mode = 'n',
          silent = true, -- use `silent` when creating keymaps
          noremap = true, -- use `noremap` when creating keymaps
          {
            '<leader>sf',
            '<cmd>Telescope find_files<cr>',
            desc = '[S]earch [F]iles',
          },
          {
            '<leader>sh',
            '<cmd>Telescope help_tags<cr>',
            desc = '[S]earch [H]elp',
          },
          {
            '<leader>sb',
            '<cmd>Telescope buffers<cr>',
            desc = '[S]earch [B]uffers',
          },
          {
            '<leader>sg',
            '<cmd>Telescope live_grep<cr>',
            desc = '[S]earch by [G]rep',
          },
          {
            '<leader>sc',
            function()
              require('telescope.builtin').find_files({
                cwd = vim.fn.stdpath('config'),
              })
            end,
            desc = '[S]earch [C]onfig files',
          },
        },
      })

      local icons = require('settings.icons')
      require('telescope').setup({
        defaults = {
          prompt_prefix = icons.ui.Telescope,
          selection_caret = icons.ui.Forward,
          entry_prefix = '  ',
          initial_mode = 'insert',
          path_display = { 'smart' },
          color_devicons = true,
          mappings = {
            i = {
              ['<C-h>'] = 'select_horizontal', -- original bind is C-x
              ['<C-t>'] = false, -- disable 'select_tab'
              ['g?'] = 'which_key', -- alternate bind (swiss keyboard troubles)
              -- swap Esc and C-c behavior
              ['<esc>'] = 'close',
              ['<C-c>'] = false, -- disable 'close'
            },
            n = {
              ['<C-h>'] = 'select_horizontal', -- original bind is C-x
              ['<C-t>'] = false, -- disable 'select_tab'
              ['q'] = 'close',
              ['g?'] = 'which_key', -- additional bind (consistency)
              -- add default binding back, removal in insert mode cascades for some reason
              ['<C-c>'] = 'close',
            },
          },
        },
        pickers = {
          live_grep = {
            additional_args = function()
              return { '--hidden' }
            end,
          },
        },
      })
    end,
  }
end
