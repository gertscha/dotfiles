-- configure debug adapter protocol
local M = {
  'mfussenegger/nvim-dap',
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

  require('user.configuration.dap_adapter_settings')

  local kopts = {
    mode = 'n', -- NORMAL mode
    prefix = '', -- the prefix is prepended to every mapping part of `mappings`
    buffer = nil, -- nil for Global mappings. Give buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false, -- use `expr` when creating keymaps
  }
  require('which-key').register({
    ['<space>i'] = {
      b = { require('dap').toggle_breakpoint, 'DAP: Toggle [b]reakpoint' },
      ['gb'] = { require('dap').run_to_cursor, 'DAP: Run to Cursor' },
      ['?'] = { function() require('dapui').eval(nil, { enter = true }) end, 'DAP: Eval under Cursor' },
      ['<F1>'] = { require('dap').continue, 'DAP: Continue' },
      ['<F2>'] = { require('dap').step_into, 'DAP: Step Into' },
      ['<F3>'] = { require('dap').step_over, 'DAP: Step Over' },
      ['<F4>'] = { require('dap').step_out, 'DAP: Step Out' },
      ['<F5>'] = { require('dap').step_back, 'DAP: Step Back' },
      ['<F10>'] = { require('dap').restart, 'DAP: Restart' },
    },
  }, kopts)

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

