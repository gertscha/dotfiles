#!/bin/bash

for file in *.pdf; do
    [ -e "$file" ] || continue

    # avoid double-processing
    if [[ "$file" == *-out.pdf ]]; then
        continue
    fi

    filename="${file%.pdf}"
    output_file="${filename}-out.pdf"

    echo "Compressing: '$file'"

    # use Ghostscript
    gs -sDEVICE=pdfwrite \
       -dCompatibilityLevel=1.4 \
       -dPDFSETTINGS=/ebook \
       -dNOPAUSE \
       -dQUIET \
       -dBATCH \
       -sOutputFile="$output_file" \
       "$file"

    if [ $? -eq 0 ]; then
        echo "Success: Created '$output_file'"
    else
        echo "Warning: Failed to compress '$file'"
    fi
done

echo "Done."
