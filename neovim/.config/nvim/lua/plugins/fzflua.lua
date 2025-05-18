local M = {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  dependencies = {
    'echasnovski/mini.icons',
    'folke/which-key.nvim',
  },
  opts = {
    -- <esc> does not terminat the proccess, allowing
    -- resume to fully recover the previous state
    'hide',
  },
}

function M.config()
  local fzflua = require('fzf-lua')

  -- which-key setup
  require('which-key').add({
    -- make sure this matches the keys entry for the plugin loading
    { '<leader>s', group = 'Search' },
    {
      '<leader><leader>',
      function()
        fzflua.resume()
      end,
      desc = 'Resume previous search',
    },
    {
      mode = 'n',
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      {
        '<leader>sf',
        function()
          fzflua.files()
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sr',
        function()
          fzflua.git_files()
        end,
        desc = '[S]earch Git [R]epository',
      },
      {
        '<leader>sh',
        function()
          fzflua.helptags()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sb',
        function()
          fzflua.buffers()
        end,
        desc = '[S]earch [B]uffers',
      },
      {
        '<leader>sw',
        function()
          fzflua.grep_cword()
        end,
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sg',
        function()
          fzflua.live_grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sj',
        function()
          fzflua.jumps()
        end,
        desc = '[S]earch [J]umplist',
      },
      {
        '<leader>ss',
        function()
          fzflua.builtin()
        end,
        desc = 'Search Builtin Pickers',
      },
      {
        '<leader>sm',
        function()
          fzflua.manpages()
        end,
        desc = '[S]earch [M]anpages',
      },
      {
        '<leader>sM',
        function()
          fzflua.marks()
        end,
        desc = '[S]earch [M]arks',
      },
      {
        '<leader>sc',
        function()
          fzflua.files({ cwd = vim.fn.stdpath('config') })
        end,
        desc = '[S]earch [C]onfig files',
      },
      {
        '<leader>sp',
        function()
          fzflua.files({ cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy') })
        end,
        desc = '[S]earch [P]lugin implementations',
      },
    },
  })
end

return M
