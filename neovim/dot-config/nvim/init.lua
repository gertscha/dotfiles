-- My Neovim Config
-- inspired by TJ DeVries and Christian Chiarulli

-- some filetype specific settings get auto run see the files in
-- 'after/ftplugin' and :help ftplugin for more info

---protected require
---@param module string
---@return table?
function P_require(module)
  local ok, m = pcall(require, module)
  if not ok then
    vim.notify(
      'P_rquire failed to load module "' .. module .. '"',
      vim.log.levels.WARN
    )
    return nil
  end
  return m
end

-- fallback indicator for Telescope
---@type boolean
Telescope_fallback = false
if vim.fn.executable('fzf') == 0 then
  Telescope_fallback = true
end

require('settings.options') -- base nvim settings
require('settings.keybinds') -- keybind adjustments
require('settings.autocmds') -- event based actions
require('template.commands') -- commands to generate template files
require('settings.lazy') -- the plugin manager (also loads the plugins)
