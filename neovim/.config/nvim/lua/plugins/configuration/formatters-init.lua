local M = {
  cpp = [[
---
BasedOnStyle: Google
---
Language: Cpp
IndentWidth: 2
ColumnLimit: 85
BreakBeforeBraces: Stroustrup
AlignTrailingComments:
  Kind:            Never
  OverEmptyLines:  0]],
  lua = [[
syntax = "All"
column_width = 85
line_endings = "Unix"
indent_type = "Spaces"
indent_width = 2
quote_style = "AutoPreferSingle"
call_parentheses = "Always"
collapse_simple_statement = "ConditionalOnly"
space_after_function_names = "Never"

[sort_requires]
enabled = false]],
 python = [[
[style]
based_on_style = google
spaces_before_comment = 1
indent_width = 4
split_before_logical_operator = true
split_all_top_level_comma_separated_values = true
split_before_dot = true
join_multiple_lines = true
column_limit = 85]],
}

return M
