-------------------------------------------------
-- Argmada.nvim
-- A small-ish Harpoon alternative
--
-- See :h argmada for configuration help
--------------------------------------------------

if vim.g.loaded_argmada == 1 then return end
vim.g.loaded_argmada = 1

---@type ArgmadaConfig
local config = vim.g.argmada_config or {}

-- default config values (remaining ones are lazy loaded)
local mark_keybind_max_index = 4
local default_select_map_prefix = '<leader>'
local default_mark_map_prefix = '<leader>a'
local default_ui_toggle = '<A-h>'
local default_map_idx_suffix = { 'm', 'n', 'b', 'v' }

-- config values by user or default
local max_idx = config.mark_keybind_max_index or mark_keybind_max_index
local keep_maps = config.keep_default_binds ~= false
local keep_ui_maps = config.keep_default_ui_binds ~= false
local map_mark_pref = config.map_mark_prefix or default_mark_map_prefix
local map_sel_pref = config.map_select_prefix or default_select_map_prefix
local map_ui_toggle = config.map_ui_toggle or default_ui_toggle
local map_suffix = config.map_idx_suffix
if map_suffix == nil then
  map_suffix = default_map_idx_suffix
elseif map_suffix == false then
  map_suffix = {}
end

--
-- Define <Plug> Targets
--
--   Base Actions
vim.keymap.set('', '<Plug>(ArgmadaToggleUI)', function()
  require('argmada').func.toggle_ui()
end)
vim.keymap.set('', '<Plug>(ArgmadaOpenUI)', function()
  require('argmada').func.open_ui()
end)
vim.keymap.set('', '<Plug>(ArgmadaCloseUI)', function()
  require('argmada').func.close_ui()
end)

vim.keymap.set('', '<Plug>(ArgmadaMarkAppend)', function()
  require('argmada').func.mark()
end)
vim.keymap.set('', '<Plug>(ArgmadaUnmarkCurrent)', function()
  require('argmada').func.unmark()
end)

vim.keymap.set('', '<Plug>(ArgmadaNext)', function()
  require('argmada').func.select_next()
end)
vim.keymap.set('', '<Plug>(ArgmadaPrev)', function()
  require('argmada').func.select_prev()
end)

vim.keymap.set('', '<Plug>(ArgmadaLoadState)', function()
  require('argmada').func.load_state()
end)
vim.keymap.set('', '<Plug>(ArgmadaSaveState)', function()
  require('argmada').func.save_state()
end)

for i = 1, max_idx do
  vim.keymap.set('', '<Plug>(ArgmadaMark' .. i .. ')', function()
    require('argmada').func.mark(i)
  end)

  vim.keymap.set('', '<Plug>(ArgmadaUnmark' .. i .. ')', function()
    require('argmada').func.unmark(i)
  end)

  vim.keymap.set('', '<Plug>(ArgmadaSelect' .. i .. ')', function()
    require('argmada').func.select(i)
  end)
end
--   UI Buffer only action
vim.keymap.set('', '<Plug>(ArgmadaSelectUI)', function()
  require('argmada').func.select_via_ui()
end)

--
-- User commands
--
vim.api.nvim_create_user_command('ArgmadaToggle', function()
  require('argmada').func.toggle_ui()
end, { desc = 'Toggle the Argmada UI' })
vim.api.nvim_create_user_command('ArgmadaOpen', function()
  require('argmada').func.open_ui()
end, { desc = 'Open the Argmada UI' })
vim.api.nvim_create_user_command('ArgmadaClose', function()
  require('argmada').func.close_ui()
end, { desc = 'Close the Argmada UI' })

--
-- Apply Default Bindings
--
if keep_maps then
  local function safe_map(mode, lhs, plug_target, desc)
    -- only add binding if action is not bound already
    if vim.fn.hasmapto(plug_target, mode) == 0 then
      vim.keymap.set(mode, lhs, plug_target, { desc = desc })
    end
  end

  safe_map('n', map_ui_toggle, '<Plug>(ArgmadaToggleUI)', 'Argmada: Toggle UI')
  safe_map('n', ']h', '<Plug>(ArgmadaNext)', 'Argmada: Next Mark')
  safe_map('n', '[h', '<Plug>(ArgmadaPrev)', 'Argmada: Previous Mark')

  for i, suffix in pairs(map_suffix) do
    -- it's fine to have more than max_idx bindings, they just will have no
    -- effect since the <Plug> target for it was not created
    safe_map(
      'n',
      map_mark_pref .. suffix,
      '<Plug>(ArgmadaMark' .. i .. ')',
      'Argmada: Mark ' .. i
    )
    safe_map(
      'n',
      map_sel_pref .. suffix,
      '<Plug>(ArgmadaSelect' .. i .. ')',
      'Argmada: Go to ' .. i
    )
  end
end
if keep_ui_maps then
  -- UI buffer bindings via FileType
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'argmada-ui-popup',
    desc = 'Argmada: Set default UI buffer mappings',
    callback = function(event)
      local map_opts = {
        buffer = event.buf,
        silent = true,
        nowait = true,
      }
      vim.keymap.set('n', '<CR>', '<Plug>(ArgmadaSelectUI)', map_opts)
      vim.keymap.set('n', 'q', '<Plug>(ArgmadaCloseUI)', map_opts)
      vim.keymap.set('n', '<ESC>', '<Plug>(ArgmadaCloseUI)', map_opts)
    end,
  })
end
