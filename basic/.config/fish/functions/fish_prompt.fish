function fish_prompt
    set -l rootuser
    if fish_is_root_user
        set rootuser "#"
    end
    string join '' -- (set_color green) (prompt_pwd -D 1 -d 3) ' ' (set_color yellow) $rootuser '➤ ' (set_color normal)
end
