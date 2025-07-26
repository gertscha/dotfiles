-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- The executables that you want to debug need to be compiled with debug symbols.

local dap = require('dap')
-- local ui = require('dapui')

-- C/C++/Rust (via cpptools)
dap.adapters.cppdbg = {
  name = 'cppdbg',
  type = 'executable',
  command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
}

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = true,
  },
}
dap.configurations.h = dap.configurations.cpp
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp



-- Handled by nvim-dap-go
-- dap.adapters.go = {
--   type = 'server',
--   port = '${port}',
--   executable = {
--     command = 'dlv',
--     args = { 'dap', '-l', '127.0.0.1:${port}' },
--   },
-- }

-- local elixir_ls_debugger = vim.fn.exepath 'elixir-ls-debugger'
-- if elixir_ls_debugger ~= '' then
--   dap.adapters.mix_task = {
--     type = 'executable',
--     command = elixir_ls_debugger,
--   }
--
--   dap.configurations.elixir = {
--     {
--       type = 'mix_task',
--       name = 'phoenix server',
--       task = 'phx.server',
--       request = 'launch',
--       projectDir = '${workspaceFolder}',
--       exitAfterTaskReturns = false,
--       debugAutoInterpretAllModules = false,
--     },
--   }
-- end
