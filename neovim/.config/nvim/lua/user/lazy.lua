-- This file should be the last to load

-- bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- we use a global table to make plugins explicit yet convenient to add
require("lazy").setup {
  spec = LAZY_PLUGIN_SPEC,
  install = {
    colorscheme = { "darkplus", "default" },
  },
  ui = {
    border = "rounded",
    size = { width = 0.8, height = 0.8 },
  },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = true, -- get a notification when new updates are found
    frequency = 36000, -- check for updates every 10 hours
  },
  performance = {
    cache = { enabled = true, },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      disabled_plugins = {
        -- "gzip",
        -- "tarPlugin",
      },
    },
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- get a notification when changes are found
  },
}
