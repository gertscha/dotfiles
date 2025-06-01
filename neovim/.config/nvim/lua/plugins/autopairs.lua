local M = {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
        disable_filetype = { 'snacks_picker_input', 'fzf' },
        disable_in_macro = true,
        fast_wrap = {},
    },
}

return M
