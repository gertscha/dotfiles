function swayimg --description 'Wrapper for swayimg with version-based config management'
    set -l now (date +%s)
    set -l cache_ttl 86400 # 24h

    if not set -q __swayimg_last_check; or test (math "$now - $__swayimg_last_check") -ge $cache_ttl
        if type -q swayimg
            set -U __swayimg_last_check $now

            set -l si_version (command swayimg --version | string match -r '[0-9]+\.[0-9]+' | head -n1)
            set -l si_major_version (string split '.' $si_version)[1]

            set -l conf_dir (or echo $XDG_CONFIG_HOME; echo ~/.config)/swayimg
            test -d $conf_dir; or mkdir -p $conf_dir

            # Perform symlinking based on version
            if test "$si_major_version" -lt 4
                ln -sf $XDG_CONFIG_HOME/swayimg.d/config_v3 $conf_dir/config
            else if test "$si_major_version" -eq 4
                ln -sf $XDG_CONFIG_HOME/swayimg.d/config_v4 $conf_dir/config
            else if test "$si_major_version" -ge 5
                ln -sf $XDG_CONFIG_HOME/swayimg.d/config_v5.lua $conf_dir/init.lua
            end
        end
    end

    command swayimg $argv
end
