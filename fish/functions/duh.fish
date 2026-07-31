# Show disk usage of current directory
function duh
    du -h -d 1 | sort -hr
end
