function fish_right_prompt
    # status
    set -l last_status $status
    set -l stat
    if test $last_status -ne 0
        set stat (set_color red)"[$last_status]"(set_color normal)
    end
    # git info
    set -g __fish_git_prompt_showupstream "informative"
    set -g __fish_git_prompt_show_informative_status 1
    set -g __fish_git_prompt_hide_untrackedfiles 1

    set -g __fish_git_prompt_color_branch yellow
    set -g __fish_git_prompt_color_branch_dirty FFA500
    set -g __fish_git_prompt_color_branch_staged purple
    set -g __fish_git_prompt_color_cleanstate green
    set -g __fish_git_prompt_color_dirtystate FFA500
    set -g __fish_git_prompt_color_stagedstate purple
    set -g __fish_git_prompt_color_invalidstate red

    set -g __fish_git_prompt_char_upstream_ahead "↑"
    set -g __fish_git_prompt_char_upstream_behind "↓"
    set -g __fish_git_prompt_char_upstream_prefix ""
    set -g __fish_git_prompt_char_stagedstate ""
    set -g __fish_git_prompt_char_dirtystate "+"
    set -g __fish_git_prompt_char_untrackedfiles "…"
    set -g __fish_git_prompt_char_conflictedstate "✖"
    set -g __fish_git_prompt_char_cleanstate "✔"

    # prompt string
    string join '' -- $stat (fish_git_prompt)
end
