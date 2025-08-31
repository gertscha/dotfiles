-- Loads the plugins
-- Setup :Plug for updating

local plugin_directory = vim.fn.stdpath('config') .. '/lua/plugins'

--
-- Helpers
--

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

---add plugin to spec
---@param spec table
---@param name string
---@param options table?
function Add_plugin(spec, name, options)
  local plugin = {
    src = 'https://github.com/' .. name,
  }
  if options then
    if options.version then plugin.version = options.version end
    if options.name then plugin.name = options.name end
  end
  table.insert(spec, plugin)
end

---centralized function to update the plugins
function Update_plugins()
  -- autocmd hooks are used where necessary for (post-)install steps
  -- see :h PackChanged
  vim.pack.update()
end

vim.api.nvim_create_user_command('Plug', function()
  Update_plugins()
end, { desc = 'Update Plugins (confirm with :w)' })

-- small local helper for priority sorting
--- create iterator over t that is sorted by keys (and comp f)
---@param t table
---@param f function?
local function pairsByKeys(t, f)
  local a = {}
  for n in pairs(t) do
    table.insert(a, n)
  end
  table.sort(a, f)
  local i = 0 -- iterator variable
  local iter = function() -- iterator function
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end

--
-- Plugin collection and installation
--

-- Find all Lua files in the directory.
local lua_files = vim.fn.glob(plugin_directory .. '/*.lua', true, true)

local plugin_spec = {}
local plugin_prio_config = {}
local plugin_config = {}

for _, file in ipairs(lua_files) do
  local plug = dofile(file)
  if type(plug.spec) == 'function' then plug.spec(plugin_spec) end
  if type(plug.config) == 'function' then
    if type(plug.priority) == 'string' then
      if plugin_prio_config[plug.priority] ~= nil then
        vim.notify(
          string.format('duplicate priority: %s', plug.priority),
          vim.log.levels.ERROR
        )
      else
        plugin_prio_config[plug.priority] = plug.config
      end
    else
      table.insert(plugin_config, plug.config)
    end
  end
end

-- get lsp setup
local lspconfig = require('lsp.init')
-- add the LSP plugins to the spec
if type(lspconfig.spec) == 'function' then lspconfig.spec(plugin_spec) end

-- load the plugins in the spec
vim.pack.add(plugin_spec)

-- run the config functions
-- first those with a priority (after sorting them)
for _, conf in pairsByKeys(plugin_prio_config) do
  conf()
end
-- then those without a priority
for _, conf in ipairs(plugin_config) do
  conf()
end

-- run the lspconfig function
if type(lspconfig.config) == 'function' then
  vim.schedule(function()
    lspconfig.config()
  end)
end
