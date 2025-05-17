-- This file should be loaded after the other settings

-- bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- Add lazy to the `runtimepath`, this allows us to `require` it
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    -- import your plugins
    { import = 'plugins' },
  },
  install = {
    missing = true, -- install missing plugins on startup
    colorscheme = { 'vague' }, -- colorscheme that will be used when installing plugins
    -- colorscheme that will be used when installing plugins.
  },
  ui = {
    -- a number < 1 is a percentage., > 1 is a fixed size
    border = 'rounded',
    size = { width = 0.8, height = 0.8 },
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = true, -- reset the package path to improve startup time
    rtp = {
      reset = true, -- reset the runtime path to $VIMRUNTIME and your config directory
      disabled_plugins = {
        -- 'gzip',
        -- 'tarPlugin',
      },
    },
  },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = true, -- get a notification when new updates are found
    frequency = 36000, -- check for updates every 10 hours
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- get a notification when changes are found
  },
  -- lazy can generate helptags from the headings in markdown readme files,
  -- so :help works even for plugins that don't have vim docs.
  -- when the readme opens with :help it will be correctly displayed as markdown
  readme = {
    enabled = true,
    root = vim.fn.stdpath('state') .. '/lazy/readme',
    files = { 'README.md', 'lua/**/README.md' },
    -- only generate markdown helptags for plugins that don't have docs
    skip_if_doc_exists = true,
  },
})
