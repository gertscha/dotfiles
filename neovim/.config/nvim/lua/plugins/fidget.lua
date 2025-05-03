return {
  "j-hui/fidget.nvim",
  tag = "v1.6.1",
  lazy = true,
  opts = {
    notification = {
      history_size = 256,
      override_vim_notify = false,
      window = {
        winblend = 0, -- allow transparency
      },
    },
    progress = {
      ignore_done_already = true,
      display = {
        done_ttl = 10,
      },
    },
  },
}
