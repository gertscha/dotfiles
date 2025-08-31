---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'akinsho/toggleterm.nvim', { version = 'v2.13.1' })
  end,
}

function M.config()
  -- terminal overlay that can be toggled
  require('toggleterm').setup({
    -- size can be a number or function which is passed the current terminal
    size = function(term)
      if term.direction == 'horizontal' then
        return vim.o.lines * 0.9
      elseif term.direction == 'vertical' then
        return vim.o.columns * 0.5
      end
    end,
    open_mapping = [[<leader>ot]],
    insert_mappings = false, -- allow open mapping in insert mode
    terminal_mappings = true, -- allow open mapping in terminals
    hide_numbers = true,
    start_in_insert = true,
    persist_mode = false,
    persist_size = false,
    -- shade_filetypes = {},
    autochdir = false, -- change current dir when neovim changes
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
    close_on_exit = true, -- close the terminal window when the process exits
    clear_env = false, -- use only env vars from `env`, passed to jobstart()
    -- Change the default shell. Can be a string or a function returning a string
    shell = vim.o.shell,
    shade_terminals = true,
    shading_factor = '-30',
    direction = 'horizontal',
  })
end

return M
