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

-- snacks notifier lsp progress
-- https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
local progress = vim.defaulttable()
vim.api.nvim_create_autocmd('LspProgress', {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= 'table' then return end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ('[%3d%%] %s%s'):format(
            value.kind == 'end' and 100 or value.percentage or 100,
            value.title or '',
            value.message and (' **%s**'):format(value.message) or ''
          ),
          done = value.kind == 'end',
        }
        break
      end
    end

    local msg = {} ---@type string[]
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner =
      { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
    vim.notify(table.concat(msg, '\n'), 'info', {
      id = 'lsp_progress',
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and ' '
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

-- generate the formatter settings files with commands
local format_defs = require('plugins.configuration.formatters-init')

vim.api.nvim_create_user_command('FormatterSetupLua', function(_)
  vim.cmd('edit stylua.toml')
  vim.api.nvim_paste(format_defs['lua'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('FormatterSetupCpp', function(_)
  vim.cmd('edit .clang-format')
  vim.api.nvim_paste(format_defs['cpp'], false, -1)
  vim.cmd('write')
end, {})

vim.api.nvim_create_user_command('FormatterSetupPython', function(_)
  vim.cmd('edit .style.yapf')
  vim.api.nvim_paste(format_defs['python'], false, -1)
  vim.cmd('write')
end, {})
