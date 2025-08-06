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
  local extensions = {}

  vim.schedule(function()
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
  end)
  vim.schedule(function()
    local chafa = vim.fn.executable('chafa')
    if chafa == 1 then
      extensions = {
        ['png'] = { 'chafa' },
        ['jpeg'] = { 'chafa' },
        ['jpg'] = { 'chafa' },
      }
    end
  end)

  local setupdone = false
  local function setupfzf()
    if minimal then
      require('fzf-lua').setup({
        fzf_colors = true, -- auto-generate from colorscheme
      })
    else
      require('fzf-lua').setup({
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
      setupdone = true
    end
  end

  -- which-key setup
  require('which-key').add({
    mode = 'n',
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    {
      '<leader><leader>',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').resume()
      end,
      desc = 'Resume previous search',
    },
    {
      '<leader>sf',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').files()
      end,
      desc = '[S]earch [F]iles',
    },
    {
      '<leader>sh',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').helptags()
      end,
      desc = '[S]earch [H]elp',
    },
    {
      '<leader>ss',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').builtin()
      end,
      desc = '[S]earch Builtin Pickers',
    },
    {
      '<leader>sb',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').buffers()
      end,
      desc = '[S]earch [B]uffers',
    },
    {
      '<leader>sw',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').grep_cword()
      end,
      desc = '[S]earch current [W]ord',
    },
    {
      '<leader>sg',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').live_grep()
      end,
      desc = '[S]earch [G]rep',
    },
    {
      '<leader>sj',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').jumps()
      end,
      desc = '[S]earch [J]umplist',
    },
    {
      '<leader>sc',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })
      end,
      desc = '[S]earch [C]onfig files',
    },
    {
      '<leader>sr',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').git_files()
      end,
      desc = '[S]earch Git [R]epository',
    },
    {
      '<leader>sR',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').registers()
      end,
      desc = '[S]earch [R]egisters',
    },
    {
      '<leader>sn',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').git_diff()
      end,
      desc = '[S]earch Git Diff',
    },
    {
      '<leader>sm',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').manpages()
      end,
      desc = '[S]earch [M]anpages',
    },
    {
      '<leader>sM',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').marks()
      end,
      desc = '[S]earch [M]arks',
    },
    {
      '<leader>sp',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').spellcheck()
      end,
      desc = '[S]earch S[p]ellcheck',
    },
    {
      '<leader>sP',
      function()
        if not setupdone then setupfzf() end
        require('fzf-lua').files({
          cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'lazy'),
        })
      end,
      desc = '[S]earch [P]lugin implementations',
    },
  })
end

return M
