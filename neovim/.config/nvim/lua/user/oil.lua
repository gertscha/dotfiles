local M = {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Oil",
  keys = { '-', desc='Open Oil FS' },
}

function M.config()
  require("oil").setup {
    default_file_explorer = false,
    columns = {
      "icon",
      -- "size",
      -- "permissions",
      -- "mtime",
    },
    delete_to_trash = false,
    show_hidden = false,
    float = {
      max_height = 30,
      max_width = 60,
    },
    use_default_keymaps = false,
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      -- ["<C-t>"] = "actions.select_tab",
      -- ["<C-p>"] = "actions.preview", -- does not work for float
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      -- ["`"] = "actions.cd", -- does not seem to work
      -- ["~"] = "actions.tcd", -- tab :cd I think
      ["gs"] = "actions.change_sort",
      -- ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      -- ["g\\"] = "actions.toggle_trash",
    },
  }

  local kopts = {
    mode = "n", -- NORMAL mode
    prefix = "", -- the prefix is prepended to every mapping part of `mappings`
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
    expr = false, -- use `expr` when creating keymaps
  }
  require("which-key").register({
    ["-"] = { "<cmd>Oil --float<CR>", 'Oil: parent dir' },
  }, kopts)

end

return M
