function fish_prompt

    set -l last_status $status
    set -l stat
    if test $last_status -ne 0
        set stat (set_color red)"[$last_status] "(set_color normal)
    end

    string join '' -- $stat (set_color green) (prompt_pwd -D 2 -d 5) (set_color normal) \
        (fish_git_prompt) \n (set_color yellow) '❯ ' (set_color normal)
end
