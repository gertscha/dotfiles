abbr --add cl clear
abbr --add .. cd ..

abbr --add gs git status
abbr --add ga git add

abbr --add coi init-conda
abbr --add cod conda deactivate
abbr --add coa conda activate

abbr --add mm rmpc
abbr --add tm bartib
abbr --add htop btop

if command -sq eza
    # runs through function 'ls' first, which calls eza
    abbr --add lsf ls -af
    abbr --add lsd ls -aD
    abbr --add ls ls -a
    abbr --add ll ls -lgah
    abbr --add lsg "ls -la | grep"
else
    abbr --add ls ls -A
    abbr --add ll ls -lAh
    abbr --add lsg "ls -lAh | grep"
end
