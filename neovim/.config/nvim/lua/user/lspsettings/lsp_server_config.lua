-- add auto install and manual configurations to this table
-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
return {

  -- html = {},
  -- pyright = {},
  -- bashls = {},
  -- golangci_lint_ls = {},
  -- codelldb = {}, -- gives error
  -- cpptools = {}, -- might need manual install
  -- rust_analyzer = {},

  texlab = {},

  -- https://clangd.llvm.org/config
  clangd = {
    filetypes = { "c", "cpp", "cc", "mpp", "ixx", "objc", "objcpp", "cuda" },
  },

  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  gopls = {
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    settings = {
      gopls = {
        completeUnimported = true,
      },
    },
    flags = {
      debounce_text_changes = 150,
      analyses = {
        unusedparams = true,
      },
    },
  },

  -- https://luals.github.io/wiki/settings/
  lua_ls = {
    -- cmd = {...},
    -- filetypes { ...},
    -- capabilities = {},
    settings = {
      Lua = {
        format = {
          enable = false,
        },
        diagnostics = {
          globals = { "vim", },
        },
        runtime = {
          version = "LuaJIT",
          special = {
            add_plugin = "require",
          },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        hint = {
          enable = false,
          arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
          await = true,
          paramName = "Disable", -- "All" | "Literal" | "Disable"
          paramType = true,
          semicolon = "All", -- "All" | "SameLine" | "Disable"
          setType = false,
        },
        telemetry = {
          enable = false,
        },
        -- completion = {
        --   callSnippet = "Replace"
        -- },
      },
    },
  },

}
