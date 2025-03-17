-- expose vims undo tree for easier access
return {
  'mbbill/undotree',
  cmd = 'UndoTreeToggle',
  keys = {
    { '<leader>u', desc = 'Open Undotree' },
  },
  config = function()
    -- change default width of the undotree buffer width
    vim.g.undotree_SplitWidth = 50
    -- set the focus to the undotree buffer
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_ShortIndicators = 1

    require('which-key').add({
      mode = 'n',     -- NORMAL mode
      silent = true,  -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Open Undotree' },
    })
  end,
}
