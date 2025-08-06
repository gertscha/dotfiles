-- auto resize buffers
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- visual feedback for line yank
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('settings-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'Visual', timeout = 150 })
  end,
})

-- restore cursor pos on file open
-- vim.api.nvim_create_autocmd('BufReadPost', {
--   pattern = '*',
--   callback = function()
--     local line = vim.fn.line('\'"')
--     if line > 1 and line <= vim.fn.line('$') then vim.cmd('normal! g\'"') end
--   end,
-- })

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', {}),
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

-- trigger linting
-- vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
--   callback = function()
--     local mod = P_require('lint')
--     if mod then
--       -- try_lint without arguments runs the linters defined in `linters_by_ft`
--       mod.try_lint()
--       -- Call `try_lint` with a linter name or a list of names to always
--       -- run specific linters, independent of the `linters_by_ft` configuration
--       -- mod.try_lint('cspell')
--     end
--   end,
-- })

-- trigger something on BufEnter once
-- local has_run = false
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = function()
--     local bufname = vim.api.nvim_buf_get_name(0)
--     if not has_run and bufname ~= "" and bufname ~= "snacks_dashboard" then
--       local snacks_indent = require('snacks.indent')
--       snacks_indent.enable()
--       has_run = true
--     end
--   end,
-- })

-- Custom event, used to trigger loading of plugins when opening a Buffer
-- we exclude some buf types to speed up their responsivness
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
  group = vim.api.nvim_create_augroup('my.lazy.trigger', { clear = false }),
  pattern = '*',
  callback = function()
    local excluded_filetypes = {
      'oil',
      'fugitive',
    }
    local current_filetype = vim.bo.filetype
    local is_excluded = false
    for _, ft in ipairs(excluded_filetypes) do
      if current_filetype == ft then
        is_excluded = true
        break
      end
    end

    if not is_excluded then
      vim.api.nvim_exec_autocmds('User', {
        pattern = 'my.lazy.trigger',
        modeline = false,
      })
    end
  end,
})

