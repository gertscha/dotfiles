-- auto resize buffers
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- visual feedback for line yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('settings-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 150 }
  end,
})

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", {}),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.scrolloff = 0
  end,
})

-- Set filetype for some extensions manually
vim.filetype.add({
  extension = {
    vert = 'glsl',
    frag = 'glsl',
  },
})
