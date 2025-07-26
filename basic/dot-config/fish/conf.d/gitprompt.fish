set -g __fish_git_prompt_showupstream "informative"
set -g __fish_git_prompt_show_informative_status yes
set -g __fish_git_prompt_showuntrackedfiles yes

set -g __fish_git_prompt_color_branch yellow
set -g __fish_git_prompt_color_branch_dirty FFA500
set -g __fish_git_prompt_color_branch_staged purple
set -g __fish_git_prompt_color_cleanstate green
set -g __fish_git_prompt_color_dirtystate blue
set -g __fish_git_prompt_color_stagedstate purple
set -g __fish_git_prompt_color_invalidstate red
set -g __fish_git_prompt_color_untrackedfiles cyan
set -g __fish_git_prompt_color_mergin 7E98E8

set -g __fish_git_prompt_char_stateseparator "|"
set -g __fish_git_prompt_char_upstream_ahead "↑"
set -g __fish_git_prompt_char_upstream_behind "↓"
set -g __fish_git_prompt_char_upstream_prefix ""
set -g __fish_git_prompt_char_stagedstate ""
set -g __fish_git_prompt_char_dirtystate "+"
set -g __fish_git_prompt_char_untrackedfiles "…"
set -g __fish_git_prompt_char_conflictedstate "✖"
set -g __fish_git_prompt_char_cleanstate "✔"
