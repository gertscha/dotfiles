local M = {
  'ibhagwan/fzf-lua',
  event = 'VeryLazy',
  dependencies = {
    'echasnovski/mini.icons',
    'folke/which-key.nvim',
  },
}

function M.config()
  local minimal = false
  if vim.fn.executable('fzf') == 1 then
    local version = vim.fn.system('fzf --version')
    local viter = string.gmatch(version, '%d+')
    local ind = 1
    for e in viter do
      -- currently fzf version >= 0.53.0 is recommended
      if ind == 2 and tonumber(e, 10) < 53 then
        minimal = true
        break
      end
      ind = ind + 1
    end
  else
    vim.notify('fzf installation not found, please install it', vim.log.ERROR)
  end

  local fzflua = require('fzf-lua')
  if minimal then
    fzflua.setup({
      fzf_colors = true, -- auto-generate from colorscheme
    })
  else
    fzflua.setup({
      -- <esc> does not terminat the proccess, allowing
      -- resume to fully recover the previous state
      -- 'hide',
      fzf_colors = true, -- auto-generate from colorscheme
      fzf_opts = {
        ['--wrap'] = true,
        ['--cycle'] = true,
      },
      -- keymap = {},
      actions = {
        files = {
          true, -- keep all the default action keybinds
          -- but disable <C-t> (open in new tab)
          ['ctrl-t'] = false,
        },
      },
    })
  end

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
