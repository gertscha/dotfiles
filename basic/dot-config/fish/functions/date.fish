function date
    set opts 'm/mine' 'l/long' 't/time' 'T/datetime' 'n/now'

    argparse -n 'date-wrapper' -is $opts -- $argv

    if set -q _flag_long;
        command date '+%a %d %B %Y'
    else if set -q _flag_mine;
        command date '+%d/%m/%g'
    else if set -q _flag_time;
        TZ="UTC" command date '+%H:%M:%S %Z'
    else if set -q _flag_datetime;
        TZ="UTC" command date '+%d/%m/%g, %H:%M:%S %Z'
    else if set -q _flag_now;
        command date '+%H:%M:%S'
    else
        command date $argv
    end
end
