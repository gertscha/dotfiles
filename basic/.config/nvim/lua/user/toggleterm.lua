-- terminal overlay that can be toggled
return {
  'akinsho/toggleterm.nvim',
  cmd = "Toggleterm",
  keys = {
    { "<c-t>", "<cmd>Toggleterm open<cr>", desc = "Toggle Terminal" },
  },
  config = function()
    local toggleterm = require("toggleterm")

    toggleterm.setup({
      size = 30,
      open_mapping = [[<c-t>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = false, -- if true, the mapping will also take effect in insert model.
      terminal_mappings = true, -- if true, the mappings take effect in the opened terminal.
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
        width = function()
          return math.floor(vim.o.columns * 0.7)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.7)
        end,
      },
    })

    -- set keybinds 
    function _G.set_terminal_keymaps()
      local opts = {noremap = true}
      -- go to normal mode
      vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
      -- move to different buffer shortcut, only make sense if not a float terminal
      -- vim.api.nvim_buf_set_keymap(0, 't', '<C-W>h', [[<C-\><C-n><C-W>h]], opts)
      -- vim.api.nvim_buf_set_keymap(0, 't', '<C-W>j', [[<C-\><C-n><C-W>j]], opts)
      -- vim.api.nvim_buf_set_keymap(0, 't', '<C-W>k', [[<C-\><C-n><C-W>k]], opts)
      -- vim.api.nvim_buf_set_keymap(0, 't', '<C-W>l', [[<C-\><C-n><C-W>l]], opts)
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

    local Terminal = require("toggleterm.terminal").Terminal

    -- disk info
    local ncdu = Terminal:new({ cmd = "ncdu", hidden = true })
    function _NCDU_TOGGLE()
      ncdu:toggle()
    end

    -- process info
    local htop = Terminal:new({ cmd = "htop", hidden = true })
    function _HTOP_TOGGLE()
      htop:toggle()
    end

    local node = Terminal:new { cmd = "node", hidden = true }
    function _NODE_TOGGLE()
      node:toggle()
    end

    local python = Terminal:new { cmd = "python", hidden = true }
    function _PYTHON_TOGGLE()
      python:toggle()
    end

    local cargo_run = Terminal:new { cmd = "cargo run", hidden = true }
    function _CARGO_RUN()
      cargo_run:toggle()
    end

    local cargo_test = Terminal:new { cmd = "cargo test", hidden = true }
    function _CARGO_TEST()
      cargo_test:toggle()
    end

    -- vim.keymap.set("t", "<c-p>", "<cmd>lua _PYTHON_TOGGLE()<CR>", { noremap = true, silent = true })
    -- vim.keymap.set("t", "<c-r>", "<cmd>lua _CARGO_TEST()<CR>", { noremap = true, silent = true })

  end,
}

