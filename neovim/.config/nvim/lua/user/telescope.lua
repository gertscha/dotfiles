-- helpers
-- make file paths look like comments in telescope
vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
    vim.fn.matchadd("TelescopeParent", "\t\t.*$")
    vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
  end)
end,
})
-- show the file name first and the path at the end
local function filenameFirst(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then return tail end
  return string.format("%s\t\t%s", tail,parent)
end

-- fuzzy finder
local M = {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.5',
  cmd = "Telescope",
  keys = {
    { '<leader>s', desc='Telescope' },
    { '<leader>sf', desc='[S]earch [F]iles' },
    { '<leader>sb', desc='[S]earch [B]uffers' },
    { '<leader>sr', desc='[S]earch Git [R]epository' },
    { '<leader>sh', desc='[S]earch [H]elp' },
    { '<leader>sw', desc='[S]earch current [W]ord' },
    { '<leader>sg', desc='[S]earch by [G]rep' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  opts = function()
    local icons = require("settings.icons")
    local actions = require("telescope.actions")
    require("telescope").setup {
      defaults = {
        prompt_prefix = icons.ui.Telescope .. " ",
        selection_caret = icons.ui.Forward .. " ",
        entry_prefix = "   ",
        initial_mode = "insert",
        selection_strategy = "reset",
        path_display = { "smart" },
        color_devicons = true,
        mappings = {
          n = {
            ["<esc>"] = actions.close,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
        find_files = {
          theme = "dropdown",
          previewer = false,
          path_display = filenameFirst,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          path_display = filenameFirst,
        },
      },
    }
  end,
}

function M.config()
  -- which-key setup this is the default
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
    ["<leader>"] = {
      s = {
        name = "Telescope",
        f = { "<cmd>Telescope find_files<cr>", '[S]earch [F]iles' },
        b = { "<cmd>Telescope buffers<cr>", '[S]earch [B]uffers' },
        r = { "<cmd>Telescope git_files<cr>", '[S]earch Git [R]epository' },
        h = { "<cmd>Telescope help_tags<cr>", '[S]earch [H]elp' },
        w = { "<cmd>Telescope grep_string<cr>", '[S]earch current [W]ord' },
        g = { "<cmd>Telescope live_grep<cr>", '[S]earch by [G]rep' },
      },
    },
  }, kopts)

end

return M

