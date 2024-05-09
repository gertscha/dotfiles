local M = {
  "nvim-tree/nvim-web-devicons",
  commit = '20921d33c605ba24c8d0b76b379a54a9c83ba170', -- last working
  -- next commit breaks with my alpha.nvim config on line 75
  -- fails with: nvalid highlight name: 'Dev IconKdenlive-layoutsrc'
  -- or: Invalid highlight name: 'DevIconTrisquel_GNU-L inux'
  -- the call looks good, from docs:
  -- require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
  -- the inputs look good as well, changing or removing the highlight has no effect
  -- using: require("nvim-web-devicons").get_icon_by_filetype(filetype, opts)
  -- also failed, for now reverting to the previous commit
  event = "VeryLazy",
}

function M.config()
  require "nvim-web-devicons"
end

return M

