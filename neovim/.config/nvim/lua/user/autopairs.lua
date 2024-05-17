local M = {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {}
}

-- has many more advanced features
-- most notably: fast_wrap
-- function M.setup()
--   local opts = {
--     check_ts = false,
--     disable_in_macro = true,
--     disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'oil' },
--     fast_wrap = {
--       map = '<leader>e',
--       chars = { '{', '[', '(', '"', "'" },
--       pattern = [=[[%'%"%>%]%)%}%,]]=],
--       end_key = '$',
--       before_key = 'h',
--       after_key = 'l',
--       cursor_pos_before = true,
--       keys = 'qwertyuiopzxcvbnmasdfghjkl',
--       manual_position = true,
--       highlight = 'Search',
--       highlight_grey='Comment'
--     },
--   }
--   require('nvim-autopairs').setup(opts)
-- end

return M

