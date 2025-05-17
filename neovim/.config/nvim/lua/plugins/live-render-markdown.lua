local M = {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'echasnovski/mini.icons',
  },
  cmd = 'RenderMarkdown',
  keys = {
    { '<leader>omb', desc = 'Markdown Preview Buffer (in-place)' },
  },
  ft = { 'markdown' }, -- autoload
}

function M.config()
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
      vim.log.WARN
    )
  end

  require('render-markdown').setup({
    completions = { blink = { enabled = true } },
    render_modes = { 'n' }, -- disable all previews in insert mode
    latex = { enabled = has_latex2text },
  })

  require('which-key').add({
    mode = 'n', -- NORMAL mode
    buffer = nil, -- nil for Global mappings. Give buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    {
      '<leader>omb',
      '<cmd>RenderMarkdown toggle<cr>',
      desc = 'Markdown Preview Buffer (in-place) toggle',
    },
  })
end

return M
