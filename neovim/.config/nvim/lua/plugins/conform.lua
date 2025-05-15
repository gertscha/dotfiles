local M = {
  'stevearc/conform.nvim',
  -- TODO see if this really makes sense
  lazy = true, -- currently loaded from LSP
  depedencies = {
    'mason-org/mason.nvim',
  },
  opts = {
    -- You can customize some of the format options for the filetype
    -- (:help conform.format)
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform will run multiple formatters sequentially, if not stopped
      python = { 'isort', 'yapf' },
      rust = { 'rustfmt', stop_after_first = true },
    },
    -- Set this to change the default values when calling conform.format()
    default_format_opts = {
      lsp_format = 'fallback',
      indent = 'space', -- TODO check if this does anything (don't think its valid)
    },
  },
}

function M.config()
  -- TODO integrate the opts and this table to have a single config location
  local packages = { 'yapf', 'isort' }

  -- TODO see if and how one can extend the opt table
  local formatters_ft = {
    lua = { 'stylua' },
    python = { 'isort', 'yapf' },
    rust = { 'rustfmt', stop_after_first = true, lsp_format = 'fallback' },
  }

  -- how I could iterate over the formatters only, instead of using the packages list
  -- for k, v in pairs(formatters_ft) do
  --   print(k)
  --   for kk, vv in pairs(v) do
  --     if type(kk) == "number" then
  --       print(vv)
  --     else
  --       print('other value:')
  --       print(kk)
  --       print(vv)
  --     end
  --   end
  -- end


  -- ensure all the packages are installed
  local registry = P_require('mason-registry')
  if registry then
    for i = 1, #packages do
      local exists = registry.has_package(packages[i])
      local p = packages[i]
      if exists then
        local installed = registry.is_installed(packages[i])
        if not installed then
          local msg = string.format('Installing %s with Mason!', p)
          vim.notify(msg, vim.log.WARN)
          registry.get_package(p):install()
        end
      else
        vim.notify(string.format('Formatter "%s" not found!', p), vim.log.INFO)
      end
    end
  end

  -- alternative way to configure a formatter
  -- require('conform').formatters.stylua = {
  --   env = {
  --     ENV_VAR = 'value'
  --   },
  -- }
end

return M
