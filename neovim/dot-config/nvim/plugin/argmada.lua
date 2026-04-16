-------------------------------------------------
-- Argmada.nvim
-- A small-ish Harpoon alternative
--
-- See :h argmada for configuration help
--------------------------------------------------

if vim.g.loaded_argmada == 1 then return end
vim.g.loaded_argmada = 1

local config = vim.g.argmada_config or {}

-- default value for config.mark_keybind_max_index
local default_jump_count = 4

--
-- Define <Plug> Keybinds
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

local max_idx = config.mark_keybind_max_index or default_jump_count
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
-- Apply Default Bindings
--
if config.keep_default_binds ~= false then
  local function safe_map(mode, lhs, plug_target, desc)
    -- only add binding if action is not bound already
    if vim.fn.hasmapto(plug_target, mode) == 0 then
      vim.keymap.set(mode, lhs, plug_target, { desc = desc })
    end
  end

  -- Base default bindings
  safe_map('n', '<C-h>', '<Plug>(ArgmadaToggleUI)', 'Argmada: Toggle UI')
  safe_map('n', '<C-s>', '<Plug>(ArgmadaMarkAppend)', 'Argmada: Append new Mark')
  safe_map('n', ']h', '<Plug>(ArgmadaNext)', 'Argmada: next Mark')
  safe_map('n', '[h', '<Plug>(ArgmadaPrev)', 'Argmada: previous Mark')
  safe_map('n', '<leader>hc', '<Plug>(ArgmadaUnmarkCurrent)', 'Argmada: Remove Mark')

  -- Map the numbered defaults safely (respecting max_idx)
  -- should have length: default_jump_count
  local mark_defaults = { '<leader>am', '<leader>an', '<leader>ab', '<leader>av' }
  local select_defaults = { '<leader>m', '<leader>n', '<leader>b', '<leader>v' }

  -- max_idx from the config sets the maximum for the <Plug> bindings
  for i = 1, math.min(max_idx, default_jump_count) do
    -- Only map if we actually have a default key defined for this index
    if mark_defaults[i] then
      safe_map(
        'n',
        mark_defaults[i],
        '<Plug>(ArgmadaMark' .. i .. ')',
        'Argmada: Mark ' .. i
      )
      safe_map(
        'n',
        select_defaults[i],
        '<Plug>(ArgmadaSelect' .. i .. ')',
        'Argmada: Go to ' .. i
      )
    end
  end
end

if config.keep_default_ui_binds ~= false then
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
      if vim.fn.hasmapto('<Plug>(ArgmadaSelectUI)', 'n') == 0 then
        vim.keymap.set('n', '<CR>', '<Plug>(ArgmadaSelectUI)', map_opts)
      end
      if vim.fn.hasmapto('<Plug>(ArgmadaCloseUI)', 'n') == 0 then
        vim.keymap.set('n', 'q', '<Plug>(ArgmadaCloseUI)', map_opts)
        vim.keymap.set('n', '<ESC>', '<Plug>(ArgmadaCloseUI)', map_opts)
      end
    end,
  })
end
