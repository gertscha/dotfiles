function fish_prompt
    set -l last_status $status
    set -l stat
    set_color blue
    if set -q CONDA_DEFAULT_ENV
        echo -n "($CONDA_DEFAULT_ENV) "
    end
    set_color normal
    set_color green
    echo -n (prompt_pwd -D 2 -d 5)
    set_color normal
    echo (fish_git_prompt)
    if test $last_status -ne 0
        set stat (set_color red)"[$last_status] "
        echo -n $stat
    end
    set_color yellow 
    echo -n '❯ '
    set_color normal
end
