-- add auto install and manual configurations to this table
-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
return {

  pyright = true,
  zls = true,
  glsl_analyzer = true,

  bashls = true,
  texlab = true,
  rust_analyzer = true,

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
          paramName = "Disable",  -- "All" | "Literal" | "Disable"
          paramType = true,
          semicolon = "All",      -- "All" | "SameLine" | "Disable"
          setType = false,
        },
        telemetry = {
          enable = false,
        },
        completion = {
          callSnippet = "Both"
        },
      },
    },
  },


  -- html = true,
  -- cssls = true,
  -- golangci_lint_ls = true,
  -- codelldb = true, -- gives error
  -- cpptools = true, -- might need manual install
  -- 'stylua',
  -- 'asm-lsp',
  -- 'cmake-language-server',
  -- 'golangci-lint-langserver',
  -- 'html-lsp',
  -- 'htmx-lsp',
  -- 'java-language-server',
  -- 'jq-lsp',
  -- 'json-lsp',
  -- 'markdown-oxide',
  -- 'marksman',
  -- 'ocaml-lsp',
  -- 'pyright',
  -- 'python-lsp-server',
  -- 'zls',

  -- DAP's
  -- 'cpptools',
  -- 'codelldb',
  -- 'go-debug-adapter',
  -- 'debugpy',
  -- 'java-debug-adapter,
  -- 'java-language-server,
  -- 'ocamlearlybird,

  -- Formatters

  -- Linters
}
