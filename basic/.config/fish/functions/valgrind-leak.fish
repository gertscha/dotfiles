function valgrind-leak
    valgrind -s --trace-children=yes --leak-check=full --show-leak-kinds=all $argv
end
