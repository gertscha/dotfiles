-- Global Variables
-- table for all the plugin specs
LAZY_PLUGIN_SPEC = {}
-- auto setup lsp servers
LSP_SERVERS = {
  "lua_ls",
  -- "html",
  -- "pyright",
  -- "bashls",
  "texlab",
  'rust_analyzer',
  'clangd',
  'gopls',
  -- 'golangci_lint_ls',
  -- 'codelldb', -- gives error
  -- 'cpptools', -- might need manual install
}

-- function to add specs to the table
local function add_plugin(plugin_config)
  table.insert(LAZY_PLUGIN_SPEC, { import = plugin_config })
end

-- setup
require "settings.options"
require "settings.keybinds"
require "settings.autocmds"
add_plugin "user.colorscheme"
add_plugin "user.devicons"
add_plugin "user.move" -- move lines around
add_plugin "user.comment"
add_plugin "user.which-key"
add_plugin "user.oil" -- a filemanager
add_plugin "user.lualine" -- status line
add_plugin "user.alpha" -- start screen
add_plugin "user.undotree"
add_plugin "user.harpoon" -- file switcher
add_plugin "user.treesitter"
add_plugin "user.fugitive" -- git integration
add_plugin "user.gitsigns"
add_plugin "user.mason"
add_plugin "user.lspconfig"
add_plugin "user.cmp" -- autocompletion
add_plugin "user.telescope" -- fuzzy finder
add_plugin "user.wininfo" -- Breadcrumbs, show context info 
-- add_plugin "user.schemastore"
-- add_plugin "user.autopairs"
-- add_plugin "user.toggleterm"
-- add_plugin" user.ufo" -- no config file yet
-- add_plugin" user.neotab" -- no config file yet
require "user.lazy"

