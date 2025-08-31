---@return { spec: function, config: nil|function, priority: nil|string }

local M = {
  spec = function(spec)
    Add_plugin(spec, 'vague2k/vague.nvim', { version = 'v1.5.0' })
    Add_plugin(spec, 'rebelot/kanagawa.nvim', nil)
  end,
  priority = 'b'
}

function M.config()
  require('vague').setup({
    transparent = true, -- i.e. don't set background color
    -- bold/italic global setting in `style`s, i.e. on/off
    bold = true,
    italic = true,
    style = {
      -- "none" is the same as default
      -- general
      headings = 'bold',
      error = 'bold',
      comments = 'italic',
      boolean = 'none',
      number = 'none',
      float = 'none',
      conditionals = 'none',
      functions = 'none',
      operators = 'none',
      strings = 'none',
      variables = 'none',
      -- keywords
      keywords = 'none',
      keyword_return = 'none',
      keywords_loop = 'none',
      keywords_label = 'none',
      keywords_exception = 'none',
      -- builtin
      builtin_constants = 'none',
      builtin_functions = 'none',
      builtin_types = 'none',
      builtin_variables = 'none',
    },
    -- plugin styles where applicable
    plugins = {},
    -- Override colors
    colors = {
      bg = '#141415',
      fg = '#cdcdcd',
      floatBorder = '#878787',
      line = '#252530',
      comment = '#606079',
      builtin = '#b4d4cf',
      func = '#c48282',
      string = '#e8b589',
      number = '#e0a363',
      property = '#c3c3d5',
      constant = '#aeaed1',
      parameter = '#bb9dbd',
      visual = '#333738',
      error = '#d8647e',
      warning = '#f3be7c',
      hint = '#7e98e8',
      operator = '#90a0b5',
      keyword = '#6e94b2',
      type = '#9bb4bc',
      search = '#405065',
      plus = '#7fa563',
      delta = '#f3be7c',
    },
  })

  vim.cmd('colorscheme vague')
  vim.cmd('hi statusline guibg=NONE')
end

return M
