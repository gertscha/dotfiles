-- auto resize buffers
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

-- visual feedback for line yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
  end,
})

-- allow q to close more windows
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    -- "Jaq",
    -- "qf",
    -- "git",
    "help",
    "man",
    "lspinfo",
    "oil",
    -- "spectre_panel",
    -- "lir",
    -- "DressingSelect",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})


