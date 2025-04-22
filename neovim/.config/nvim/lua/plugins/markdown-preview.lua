local M = {
  "iamcco/markdown-preview.nvim",
  build = function()
    require("lazy").load({ plugins = { "markdown-preview.nvim" } })
    vim.fn["mkdp#util#install"]()
  end,
  event = 'VeryLazy',
  -- cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  -- keys = {
  --   {
  --     "<leader>omp",
  --     "<cmd>MarkdownPreviewToggle<cr>",
  --     desc = "Markdown Preview",
  --   },
  -- },
}

function M.config()
  require('which-key').add({
    mode = 'n',     -- NORMAL mode
    buffer = nil,   -- nil for Global mappings. Give buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '<leader>omp', '<cmd>MarkdownPreviewToggle<cr>', desc = 'Markdown Preview' },
  })
end

return M
