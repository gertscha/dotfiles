local M = {
  'mfussenegger/nvim-lint',
  lazy = true, -- currently loaded from LSP
  depedencies = {
    'mason-org/mason.nvim',
  },
  -- cmd = '?',
}

function M.config()
  local lint = require('lint')
  local linters = {
    lua = { 'luac' },
    python = { 'ruff' },
    sh = { 'bash' },
    c = { 'cppcheck' },
    css = { 'stylelint' },
    html = { 'htmlhint' },
  }

  -- Some linters require a file to be saved to disk, others support linting stdin input.
  -- For such linters you could also define a more aggressive autocmd,
  -- for example on the InsertLeave or TextChanged events.
  -- To get the filetype of a buffer you can run := vim.bo.filetype.

  -- customizaton
  local cppcheck = lint.linters.cppcheck
  cppcheck.args = {
    '--check-level=exhaustive',
  }

  require('which-key').add({
    mode = 'n', -- NORMAL mode
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '<leader>dl', lint.try_lint, desc = 'Lint Buffer' },
    {
      '<leader>dL',
      function()
        lint.try_lint('cspell')
      end,
      desc = 'Lint Spellcheck',
    },
    {
      '<leader>dRl',
      function()
        vim.diagnostic.reset(
          lint.get_namespace('cspell'),
          vim.api.nvim_get_current_buf()
        )
      end,
      desc = 'LSP: Reset Spellcheck Linter',
    },
  })

  -- install Linters with Mason if possible, notify if Linter is missing
  local registry = P_require('mason-registry')
  if registry then
    local seen = {}
    for lang, settings in pairs(linters) do
      for kk, pkg in pairs(settings) do
        if type(kk) == 'number' then
          -- guard against duplicate servers entries
          if seen[pkg] == nil then
            seen[pkg] = true
            local exists = registry.has_package(pkg)
            if exists then
              -- guard against repeated installs
              local installed = registry.is_installed(pkg)
              if not installed then
                local msg = string.format('Installing "%s" with Mason', pkg)
                vim.notify(msg, vim.log.levels.INFO)
                registry.get_package(pkg):install()
              end
            else
              if vim.fn.executable(pkg) == 0 then
                vim.notify(
                  string.format(
                    'Linter "%s" not found (not available in Mason)!',
                    pkg
                  ),
                  vim.log.levels.WARN
                )
              end
            end
          end
        end
      end
    end
  else
    vim.notify('Mason not available to install formatters', vim.log.levels.WARN)
  end

  -- set the linters
  lint.linters_by_ft = linters
end

return M
