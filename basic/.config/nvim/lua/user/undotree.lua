-- expose vims undo tree for easier access
return {
  'mbbill/undotree',
  cmd = "UndoTreeToggle",
  keys = {
    { "<leader>u", desc = "Open Undotree" },
  },
  config = function()
    -- change default width of the undotree buffer width
    vim.g.undotree_SplitWidth = 50
    -- set the focus to the undotree buffer
    vim.g.undotree_SetFocusWhenToggle = 1

    -- this is the default
    local kopts = {
      mode = "n", -- NORMAL mode
      prefix = "", -- the prefix is prepended to every mapping part of `mappings`
      buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
      expr = false, -- use `expr` when creating keymaps
    }

    require('which-key').register({
      ["<leader>"] = {
        u =  { vim.cmd.UndotreeToggle, "Open Undotree" },
      }
    }, kopts)

  end,
}

