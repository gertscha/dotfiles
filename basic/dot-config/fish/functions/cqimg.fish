function cqimg
    argparse 'h/help' 'q/quality=' -- $argv
    or return 1

    if set -q _flag_h
        echo "Usage: cqjpg [OPTIONS] INPUT"
        echo ""
        echo "Description:"
        echo "  Small wrapper for 'magick -quality'"
        echo "  Re-encodes a JPEG files with a new quality setting"
        echo "  Outputs have the same filename but with a '-ed' suffix"
        echo ""
        echo "Options:"
        echo "  -q, --quality <int>  Set output quality (0-100). Default: 90"
        echo "  -h, --help           Show this help message"

        return 0
    end

    set quality_val 95
    if set -q _flag_q
        set quality_val $_flag_q
    end

    if test (count $argv) -ne 1
        echo "Error: Missing input file."
        echo "Usage: cqjpg <file>"
        return 1
    end
    set input_file $argv[1]

    if test "$quality_val" -lt 0; or test "$quality_val" -gt 100
        echo "Error: Quality must be between 0 and 100."
        return 1
    end

    # add "-ed" suffix
    set ext (path extension "$input_file")
    set base_path (path change-extension '' "$input_file")
    set output_file "$base_path-ed$ext"

    magick "$input_file" -quality "$quality_val" "$output_file"
end 
