---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    if vim.fn.executable('fzf') == 0 then
      vim.notify('Fzf is not installed!', vim.log.levels.WARN)
    else
      Add_plugin(spec, 'ibhagwan/fzf-lua', nil)
    end
  end,
}

function M.config()
  local minimal = false
  local extensions = {}

  vim.schedule(function()
    if vim.fn.executable('fzf') == 1 then
      vim.cmd('FzfLua register_ui_select')
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

  -- keybinds
  ---@param desc string
  ---@return table
  local function opts(desc)
    return { desc = desc, noremap = true, silent = true }
  end

  vim.keymap.set('n', '<leader><leader>', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').resume()
  end, opts('Resume previous search'))

  vim.keymap.set('n', '<leader>sf', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').files()
  end, opts('[S]earch [F]iles'))

  vim.keymap.set('n', '<leader>sh', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').helptags()
  end, opts('[S]earch [H]elp'))

  vim.keymap.set('n', '<leader>ss', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').builtin()
  end, opts('[S]earch Builtin Pickers'))

  vim.keymap.set('n', '<leader>sb', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').buffers()
  end, opts('[S]earch [B]uffers'))

  vim.keymap.set('n', '<leader>sw', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').grep_cword()
  end, opts('[S]earch current [W]ord'))

  vim.keymap.set('n', '<leader>sg', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').live_grep()
  end, opts('[S]earch [G]rep'))

  vim.keymap.set('n', '<leader>sj', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').jumps()
  end, opts('[S]earch [J]umplist'))

  vim.keymap.set('n', '<leader>sc', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').files({ cwd = vim.fn.stdpath('config') })
  end, opts('[S]earch [C]onfig files'))

  vim.keymap.set('n', '<leader>sr', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').git_files()
  end, opts('[S]earch Git [R]epository'))

  vim.keymap.set('n', '<leader>sR', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').registers()
  end, opts('[S]earch [R]egisters'))

  -- <leader>sd is used for a lsp picker
  -- group it with the other git related binds under <leader>r
  vim.keymap.set('n', '<leader>rd', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').git_diff()
  end, opts('Search Git Diff'))

  vim.keymap.set('n', '<leader>rW', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').git_worktrees()
  end, opts('Search Git Worktree'))

  vim.keymap.set('n', '<leader>rw', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').git_branches()
  end, opts('Search Git Branchej'))

  vim.keymap.set('n', '<leader>sm', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').manpages()
  end, opts('[S]earch [M]anpages'))

  vim.keymap.set('n', '<leader>sM', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').marks()
  end, opts('[S]earch [M]arks'))

  vim.keymap.set('n', '<leader>sp', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').spellcheck()
  end, opts('[S]earch S[p]ellcheck'))

  vim.keymap.set('n', '<leader>sP', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').files({
      cwd = vim.fs.joinpath(vim.fn.stdpath('data'), 'site/pack'),
    })
  end, opts('[S]earch [P]lugin implementations'))

  vim.keymap.set('n', 'grm', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').diagnostics_document()
  end, opts('LSP: diagnostics [m]essages in buffer'))
  vim.keymap.set('n', 'grM', function()
    if not setupdone then setupfzf() end
    require('fzf-lua').diagnostics_workspace()
  end, opts('LSP: diagnostics [M]essages in workspace'))
end

return M
