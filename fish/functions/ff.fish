# Find files by name
function ff
    find . -name "*$argv[1]*" -type f
end
