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

  vim.keymap.set(
    'n',
    '<leader>zn',
    '<cmd>ZkNotes<cr>',
    { desc = 'Search zk notes', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zcd',
    '<cmd>ZkNew { dir = "journal/daily" }<cr>',
    { desc = 'Create new zk daily note', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zcj',
    '<cmd>ZkNew { dir = "journal" }<cr>',
    { desc = 'Create new zk journal note', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zcn',
    '<cmd>ZkNew { dir = "notes" }<cr>',
    { desc = 'Create new zk kb note', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zcc',
    '<cmd>ZkNew<cr>',
    { desc = 'Create new zk note', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zb',
    '<cmd>ZkBacklinks<cr>',
    { desc = 'Search backlinks of current buffer', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zf',
    '<cmd>ZkLinks<cr>',
    { desc = 'Search outbound links', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zl',
    '<cmd>ZkInsertLink<cr>',
    { desc = 'Create Link at cursor position', silent = true, noremap = true }
  )
  vim.keymap.set(
    'n',
    '<leader>zt',
    '<cmd>ZkTags<cr>',
    { desc = 'Search zk tags', silent = true, noremap = true }
  )
end

return M
