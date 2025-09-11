---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'zk-org/zk-nvim', { version = 'v0.4.3' })
  end,
}
function M.config()
  require('zk').setup({
    picker = 'fzf',
    lsp = {
      name = 'zk',
      cmd = { 'zk', 'lsp' },
      filetypes = { 'markdown' },
      auto_attach = {
        enabled = true,
      },
    },
  })
end

return M
