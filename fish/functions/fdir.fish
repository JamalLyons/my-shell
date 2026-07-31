# Find directories by name (named fdir to avoid clashing with brew `fd`)
function fdir
    find . -name "*$argv[1]*" -type d
end
