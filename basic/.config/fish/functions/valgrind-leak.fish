function valgrind-leak
    command valgrind -s --trace-children=yes --leak-check=full --show-leak-kinds=all $argv
end
