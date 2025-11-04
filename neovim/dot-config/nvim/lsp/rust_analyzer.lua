---@brief
---
--- https://github.com/rust-lang/rust-analyzer
---
--- rust-analyzer (aka rls 2.0), a language server for Rust
---
---
--- See [docs](https://rust-analyzer.github.io/book/configuration.html) for extra settings. The settings can be used like this:

---@type vim.lsp.Config
return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml' }
}
