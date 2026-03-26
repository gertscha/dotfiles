-- Conform.nvim setup
-- Depends on: Mason.nvim

local nvimconform = false

if nvimconform then
  return
else
  -- configure the formatters by file type (auto installed based on this table)
  local formatters = {
    lua = { 'stylua' },
    c = { 'clang-format' },
    go = { 'gopls' },
    cpp = { 'clang-format' },
    python = { 'yapf' },
    json = { 'prettier' },
    bib = { 'bibtex-tidy' },
    tex = { 'tex-fmt', 'bibtex-tidy' },
    typ = { 'tinymist', 'typstyle', lsp_format = 'prefer' },
    -- rust = { 'rustfmt', stop_after_first = true, lsp_format = 'fallback' },
  }

  vim.schedule(function()
    -- ensure all the formatters/packages that are enabled are also installed
    local registry = P_require('mason-registry')
    if registry then
      local seen = {}
      for lang, settings in pairs(formatters) do
        for kk, pkg in pairs(settings) do
          -- is a formatter (not a setting for the filetype)
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
                vim.notify(
                  string.format('Formatter "%s" not found!', pkg),
                  vim.log.levels.WARN
                )
              end
            end
          end
        end
      end
    else
      vim.notify('Mason not available to install formatters', vim.log.levels.WARN)
    end
  end)

  local conform = require('conform')
  conform.setup({
    -- You can customize some of the format options for the filetype
    -- (:help conform.format)
    formatters_by_ft = formatters,
    -- formatters = {
    --   yapf = {
    --     prepend_args = { '--argument1', '--arg2' },
    --     env = {
    --       some_var = some_val,
    --     },
    --   },
    -- },
    -- Set this to change the default values when calling conform.format()
    default_format_opts = {
      -- lsp_format = 'fallback', -- handled in lsp-config.lua
      async = true,
      timeout_ms = 2000,
    },
  })

  -- alternative way to configure a formatter
  -- conform.formatters.stylua = {
  --   env = {
  --     ENV_VAR = 'value'
  --   },
  -- }

  nvimconform = true
end
