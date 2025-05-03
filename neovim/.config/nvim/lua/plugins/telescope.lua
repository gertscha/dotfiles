-- helpers
-- make file paths look like comments in telescope
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopeResults',
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd('TelescopeParent', '\t\t.*$')
      vim.api.nvim_set_hl(0, 'TelescopeParent', { link = 'Comment' })
    end)
  end,
})
-- show the file name first and the path at the end
local function filenameFirst(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == '.' then return tail end
  return string.format('%s\t\t%s', tail, parent)
end


-- fuzzy finder
local M = {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  cmd = 'Telescope',
  keys = { '<leader>s', desc = 'Telescope' },
  event = 'BufReadPre', -- need this since LSP on attach functionality relies Telescope
}

function M.config()
  -- which-key setup (make sure it matches the load keys)
  require('which-key').add({
    -- make sure this matches the keys entry for the plugin loading
    { '<leader>s', group = 'Telescope' },
    {
      mode = 'n',
      silent = true,  -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      { '<leader>sf', '<cmd>Telescope find_files<cr>',     desc = '[S]earch [F]iles' },
      { '<leader>sr', '<cmd>Telescope git_files<cr>',      desc = '[S]earch Git [R]epository' },
      { '<leader>sh', '<cmd>Telescope help_tags<cr>',      desc = '[S]earch [H]elp' },
      { '<leader>sb', '<cmd>Telescope buffers<cr>',        desc = '[S]earch [B]uffers' },
      { '<leader>sw', '<cmd>Telescope grep_string<cr>',    desc = '[S]earch current [W]ord' },
      { '<leader>sg', '<cmd>Telescope live_grep<cr>',      desc = '[S]earch by [G]rep' },
      { '<leader>sj', '<cmd>Telescope jumplist<cr>',       desc = '[S]earch [J]umplist' },
      { '<leader>ss', '<cmd>Telescope search_history<cr>', desc = '[S]earch [S]earch history' },
      { '<leader>sm', '<cmd>Telescope marks<cr>',          desc = '[S]earch [M]arks' },
      {
        '<leader>sc',
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath('config') }
        end,
        desc = '[S]earch [C]onfig files'
      },
      {
        '<leader>sp',
        function()
          require('telescope.builtin').find_files {
            cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy')
          }
        end,
        desc = '[S]earch [P]lugin implementations'
      },
    },
  })

  local icons = require('settings.icons')
  require('telescope').setup {
    defaults = {
      prompt_prefix = icons.ui.Telescope,
      selection_caret = icons.ui.Forward,
      entry_prefix = '  ',
      initial_mode = 'insert',
      path_display = { 'smart' },
      color_devicons = true,
      mappings = {
        i = {
          ["<C-h>"] = 'select_horizontal', -- original bind is C-x
          ["<C-t>"] = false,               -- disable 'select_tab'
          ["g?"] = 'which_key',            -- alternate bind (swiss keyboard troubles)
          -- swap Esc and C-c behavior
          ['<esc>'] = 'close',
          ["<C-c>"] = false, -- disable 'close'
        },
        n = {
          ["<C-h>"] = 'select_horizontal', -- original bind is C-x
          ["<C-t>"] = false,               -- disable 'select_tab'
          ['q'] = 'close',
          ["g?"] = 'which_key',            -- additional bind (consistency)
          -- add default binding back, removal in insert mode cascades for some reason
          ["<C-c>"] = 'close',
        },
      },
    },
    extensions = {
      fzf = {},
    },
    pickers = {
      live_grep = {
        additional_args = function()
          return { '--hidden' }
        end,
      },
      find_files = {
        theme = 'dropdown',
        previewer = false,
        path_display = filenameFirst,
      },
      buffers = {
        theme = 'dropdown',
        previewer = false,
        path_display = filenameFirst,
      },
    },
  }
  -- fidget notification telescope picker
  require("telescope").load_extension("fidget")

  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  require('telescope').load_extension('fzf')
end

return M
