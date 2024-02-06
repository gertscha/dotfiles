-- move lines and words
local M = {
  "fedepujol/move.nvim",
  event = { "BufRead", "BufNewFile" },
  dependencies = { "folke/which-key.nvim", },
}

function M.config()
  require('move').setup({
    line = {
      enable = true, -- Enables line movement
      indent = true  -- Toggles indentation
    },
    block = {
      enable = true, -- Enables block movement
      indent = true  -- Toggles indentation
    },
    word = {
      enable = true, -- Enables word movement
    },
    char = {
      enable = false -- Enables char movement
    }
  })
  -- Command	  Description	                                            Mode
  -- MoveLine	  Moves a line up or down	                                Normal
  -- MoveHChar	Moves the character under the cursor, left or right	    Normal
  -- MoveWord	  Moves the word under the cursor forwards or backwards	  Normal
  -- MoveBlock	Moves a selected block of text, up or down	            Visual
  -- MoveHBlock	Moves a visual area, left or right	                    Visual

  local remap = function(mode, keys, func, desc)
    if desc then
      desc = 'Move: ' .. desc
    end
    vim.keymap.set(mode, keys, func, { desc = desc, noremap = true, silent = true })
  end
  remap('n', '<A-j>', '<cmd>MoveLine(1)<CR>', "line down")
  remap('n', '<A-k>', '<cmd>MoveLine(-1)<CR>', "line up")
  remap('n', '<leader>wf', '<cmd>MoveWord(1)<CR>', "[W]ord [F]orward")
  remap('n', '<leader>wb', '<cmd>MoveWord(-1)<CR>', "[W]ord [B]ackward")

  -- using <cmd> instead of ':' does not work, visual block mode is unsual
  remap('v', '<A-j>', ':MoveBlock(1)<CR>', "lines down")
  remap('v', '<A-k>', ':MoveBlock(-1)<CR>', "lines up")
  remap('v', '<A-h>', ':MoveHBlock(-1)<CR>', "block left")
  remap('v', '<A-l>', ':MoveHBlock(1)<CR>', "block right")

  -- local wk = require("which-key")
  -- wk.register({
  --   ["<A-j>"] = { "<cmd>MoveLine(1)<CR>", "line down" },
  --   ["<A-k>"] = { "<cmd>MoveLine(-1)<CR>", "line up" },
  --   ["<leader>"] = {
  --     w = {
  --       f = { "<cmd>MoveWord(1)<CR>", "[W]ord [F]orward" },
  --       b = { "<cmd>MoveWord(-1)<CR>", "[W]ord [B]ackward" },
  --     },
  --   },
  -- }, { prefix = "Move:" })
  -- wk.register({
  --   -- using <cmd> instead of ':' does not work, visual block mode is unsual
  --   ["<A-j>"] = { ":MoveBlock(1)<CR>", "lines down" },
  --   ["<A-k>"] = { ":MoveBlock(-1)<CR>", "lines up" },
  --   ["<A-h>"] = { ":MoveHBlock(-1)<CR>", "block left" },
  --   ["<A-l>"] = { ":MoveHBlock(1)<CR>", "block right"},
  -- }, { prefix = "Move:", mode = "v" })
end


return M

