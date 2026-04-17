local M = {}

M.check = function()
  local health = vim.health or require('health')
  local plugin = require('argmada')
  plugin.init() -- in case checkhealth is called before the plugin is loaded

  health.start('Argmada.nvim')
  ---
  --- Check Plugin Configuration
  ---
  local config = plugin.config
  local all_good = true

  local user_conf = vim.g.argmada_config
  if type(user_conf) == 'table' then
    health.ok('Found custom configuration.')
  elseif type(user_conf) ~= 'table' then
    all_good = false
    health.error(
      string.format('vim.g.argmada_config must be a table, got: %s', type(user_conf))
    )
  else
    health.ok('No custom configuration found. Using default settings.')
  end

  -- check config types
  local expected_types = {
    enable_autosave = 'boolean',
    append_to_end = 'boolean',
    ui_after_padding = 'number',
    ui_width = 'number',
    cleanup_days_limit = 'number',
    mark_keybind_max_index = 'number',
    map_ui_toggle = 'string',
    map_select_prefix = 'string',
    map_mark_prefix = 'string',
    map_idx_suffix = 'table',
    keep_default_binds = 'boolean',
    keep_default_ui_binds = 'boolean',
  }
  local config_errors = 0
  for key, val in pairs(user_conf) do
    local expected = expected_types[key]
    if not expected then
      health.warn(string.format("Unknown configuration key: '%s'", key))
      config_errors = config_errors + 1
    elseif type(val) ~= expected then
      health.error(
        string.format(
          "Invalid type for '%s'. Expected %s, got %s",
          key,
          expected,
          type(val)
        )
      )
      config_errors = config_errors + 1
    end
  end
  if user_conf.map_idx_suffix and type(user_conf.map_idx_suffix) == 'table' then
    for i, suffix in ipairs(user_conf.map_idx_suffix) do
      if type(suffix) ~= 'string' then
        health.error(
          string.format(
            'Invalid type in map_idx_suffix at index %d. Expected string, got %s',
            i,
            type(suffix)
          )
        )
        config_errors = config_errors + 1
      end
    end
  end
  if config_errors ~= 0 then
    all_good = false
    health.warn(
      string.format('Found %d problems in the plugin config', config_errors)
    )
  end

  local suffixes = config.map_idx_suffix or {}
  if #suffixes > config.mark_keybind_max_index then
    all_good = false
    health.warn('More keybinds set than mark_keybind_max_index is set to support')
    health.info(
      '   Reduce the nubmer of entries in map_idx_suffix or increase mark_keybind_max_index'
    )
  end



  if all_good then health.ok('Configuration of Argmada has no detected problems') end
end

return M
