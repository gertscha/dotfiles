---@return { spec: function, config: nil|function, priority: nil|string }

-- dependencies: fzf-lua, nvim-treesitter, mini.icons

local M = {
  spec = function(spec)
    Add_plugin(spec, 'brianhuster/live-preview.nvim', { version = 'v0.9.5' })
    Add_plugin(
      spec,
      'MeanderingProgrammer/render-markdown.nvim',
      { version = 'v8.8.0' }
    )
  end,
}

function M.config()
  --
  -- Live Preview (in the browser)
  --

  -- vim.schedule(function()
  --   require('livepreview.config').set({
  --     port = 5500,
  --     browser = 'default',
  --     dynamic_root = false,
  --     sync_scroll = true,
  --     picker = '',
  --   })
  -- end)

  vim.keymap.set(
    'n',
    '<leader>oms',
    '<cmd>LivePreview start<cr>',
    { desc = 'Markdown Preview start', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>omc',
    '<cmd>LivePreview close<cr>',
    { desc = 'Markdown Preview close', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>omp',
    '<cmd>LivePreview pick<cr>',
    { desc = 'Markdown Preview pick', silent = true, noremap = true }
  )

  --
  -- Render Markdown (in place using highlights and icons)
  --
  vim.schedule(function()
    local has_latex2text = vim
      .system({
        'python3',
        '-c',
        "import importlib.util as u; import sys; sys.exit(0 if u.find_spec('pylatexenc') else 1)",
      })
      :wait()['code'] == 0

    if not has_latex2text then
      vim.notify(
        'render-markdown disabled for LaTex, install Python "pylatexenc" to enable',
        vim.log.levels.WARN
      )
    end

    require('render-markdown').setup({
      completions = { blink = { enabled = true } },
      render_modes = { 'n' }, -- disable all previews in insert mode
      latex = { enabled = has_latex2text },
    })
  end)

  vim.keymap.set('n', '<leader>omb', '<cmd>RenderMarkdown toggle<cr>', {
    desc = 'Markdown Preview Buffer (in-place) toggle',
    silent = true,
    noremap = true,
  })
end

return M
