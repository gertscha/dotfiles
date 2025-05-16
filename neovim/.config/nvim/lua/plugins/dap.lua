-- configure debug adapter protocol
local M = {
  'mfussenegger/nvim-dap',
  enabled = false,
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    'nvim-neotest/nvim-nio',
    -- 'leoluz/nvim-dap-go',
    -- 'williamboman/mason.nvim',
    'folke/which-key.nvim',
  },
}

function M.config()
  local dap = require('dap')
  local ui = require('dapui')

  require('nvim-dap-virtual-text').setup({})

  require('plugins.configuration.dap_adapter_settings')

  local func_eval = function() require('dapui').eval(nil, { enter = true }) end
  require('which-key').add({
    mode = 'n',     -- NORMAL mode
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    { '<space>i',   group = 'DAP' },
    { '<space>ib',  require('dap').toggle_breakpoint, desc = 'DAP: Toggle [b]reakpoint' },
    { '<space>igb', require('dap').run_to_cursor,     desc = 'DAP: Run to Cursor' },
    { '<space>i?',  func_eval,                        desc = 'DAP: Eval under Cursor' },
    { '<F1>',       require('dap').continue,          desc = 'DAP: Continue' },
    { '<F2>',       require('dap').step_into,         desc = 'DAP: Step Into' },
    { '<F3>',       require('dap').step_over,         desc = 'DAP: Step Over' },
    { '<F4>',       require('dap').step_out,          desc = 'DAP: Step Out' },
    { '<F5>',       require('dap').step_back,         desc = 'DAP: Step Back' },
    { '<F10>',      require('dap').restart,           desc = 'DAP: Restart' },
  })

  dap.listeners.before.attach.dapui_config = function()
    ui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    ui.open()
  end
  dap.listeners.before.event_terminated.dapui_config = function()
    ui.close()
  end
  dap.listeners.before.event_exited.dapui_config = function()
    ui.close()
  end
end

return M
