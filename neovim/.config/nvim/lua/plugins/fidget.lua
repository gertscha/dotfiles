return {
  "j-hui/fidget.nvim",
  tag = "v1.5.0",
  opts = {
    notification = {
      history_size = 256,
      override_vim_notify = false,
      window = {
        winblend = 0, -- allow transparency
      },
    },
    progress = {
      display = {
        done_ttl = 15,
      },
    },
  },
  lazy = true,
}
