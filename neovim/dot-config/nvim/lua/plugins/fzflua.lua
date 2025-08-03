local M = {
  enabled = not Telescope_fallback,
  'ibhagwan/fzf-lua',
  cmd = 'FzfLua',
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
  end

  local chafa = vim.fn.executable('chafa')
  local extensions = {}
  if chafa == 1 then
    extensions = {
      ['png'] = { 'chafa' },
      ['jpeg'] = { 'chafa' },
      ['jpg'] = { 'chafa' },
    }
  end

  local fzflua = require('fzf-lua')
  if minimal then
    fzflua.setup({
      fzf_colors = true, -- auto-generate from colorscheme
    })
  else
    fzflua.setup({
      -- <esc> does not terminate the process, allowing
      -- resume to fully recover the previous state
      -- 'hide',
      fzf_colors = true, -- auto-generate from colorscheme
      fzf_opts = {
        ['--wrap'] = true,
        ['--cycle'] = true,
      },
      keymap = {
        fzf = { ['ctrl-q'] = 'select-all+accept' }, -- add all to QF list
      },
      actions = {
        files = {
          true, -- keep all the default action keybinds
          -- but disable <C-t> (open in new tab)
          ['ctrl-t'] = false,
          ['ctrl-q'] = false,
          ['alt-Q'] = false,
        },
      },
      winopts = { fullscreen = true },
      previewers = { builtin = { extensions = extensions } },
    })
  end

  -- which-key setup
  require('which-key').add({
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
        '<leader>sh',
        function()
          fzflua.helptags()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>ss',
        function()
          fzflua.builtin()
        end,
        desc = '[S]earch Builtin Pickers',
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
        desc = '[S]earch [G]rep',
      },
      {
        '<leader>sj',
        function()
          fzflua.jumps()
        end,
        desc = '[S]earch [J]umplist',
      },
      {
        '<leader>sc',
        function()
          fzflua.files({ cwd = vim.fn.stdpath('config') })
        end,
        desc = '[S]earch [C]onfig files',
      },
      {
        '<leader>sr',
        function()
          fzflua.git_files()
        end,
        desc = '[S]earch Git [R]epository',
      },
      {
        '<leader>sR',
        function()
          fzflua.registers()
        end,
        desc = '[S]earch [R]egisters',
      },
      {
        '<leader>sn',
        function()
          fzflua.git_diff()
        end,
        desc = '[S]earch Git Diff',
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
        '<leader>sp',
        function()
          fzflua.spellcheck()
        end,
        desc = '[S]earch S[p]ellcheck',
      },
      {
        '<leader>sP',
        function()
          fzflua.files({ cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy') })
        end,
        desc = '[S]earch [P]lugin implementations',
      },
    },
  })
end

return M
