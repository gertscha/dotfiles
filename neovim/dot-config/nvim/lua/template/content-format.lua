return {
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

  cppalt = [[
---
BasedOnStyle: Google
---
Language: Cpp
IndentWidth: 4
ColumnLimit: 85
AlignTrailingComments:
  Kind:            Never
  OverEmptyLines:  0
AlwaysBreakAfterDefinitionReturnType: All
MaxEmptyLinesToKeep: 2
SpacesBeforeTrailingComments: 2
BreakBeforeBraces: Custom
BraceWrapping:
  AfterControlStatement: MultiLine
  AfterFunction: true
  BeforeCatch: true
  BeforeElse: true
  AfterClass: false
  AfterEnum: false
  AfterNamespace: false
  AfterStruct: false
  AfterUnion: false
  AfterObjCDeclaration: false
  BeforeLambdaBody: false
  BeforeWhile: false
  IndentBraces: false
  SplitEmptyFunction: false
  SplitEmptyRecord: false
  SplitEmptyNamespace: false]],

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

  editorconfig = [[
# this is the top-most EditorConfig file
root = true
# defaults for all file types
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
[*.py]
indent_style = space
indent_size = 4
[Makefile]
indent_style = tab
[{src/**.c,src/**.h}]
indent_style = space
indent_size = 2]],
}
