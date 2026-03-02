---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'lewis6991/gitsigns.nvim', { version = 'v2.0.0' })
  end,
}

function M.config()
  require('gitsigns').setup({
    signs = {
      add = { text = '┃' },
      change = { text = '┋' },
      delete = { text = '' },
      topdelete = { text = '' },
      changedelete = { text = '┃' },
      untracked = { text = '' },
    },
    signs_staged_enable = true,
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = { interval = 4000, follow_files = true },
    auto_attach = true,
    attach_to_untracked = false,
    -- use <leader>rb to see the git blame directly
    current_line_blame = false, -- Toggle `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 3000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 6,
    update_debounce = 200,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'rounded',
      style = 'minimal',
      relative = 'cursor',
      row = 1,
      col = 1,
    },

    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, desc)
        local opts = {}
        opts.desc = desc
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, 'next git hunk')

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, 'previous git hunk')

      -- Text object
      map({ 'o', 'x' }, 'gh', gitsigns.select_hunk, 'git hunk textobject')

      map('n', '<leader>rb', function()
        gitsigns.blame_line({ full = true })
      end, 'git blame (line)')

      map('n', '<leader>rQ', function()
        gitsigns.setqflist('all')
      end)
      map('n', '<leader>rq', gitsigns.setqflist)

      -- for proper git actions I use fugitive
    end,
  })
end

return M
