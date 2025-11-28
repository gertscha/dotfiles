function swayimg
    set -l si_version_output (command swayimg --version)
    set -l si_version (echo $si_version_output | string match -r '[0-9]+\.[0-9]+' | head -n1)
    set -l si_major_version (echo $si_version | cut -d. -f1)

    if test $si_major_version -lt 4
        command swayimg --config-file="$HOME/.config/swayimg/config_v3" $argv
    else
        command swayimg $argv
    end
end
