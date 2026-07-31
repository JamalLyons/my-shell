# Open a file in macOS Quick Look
function ql
    if test (count $argv) -eq 0
        echo "Usage: ql <file>..."
        return 1
    end
    qlmanage -p $argv >/dev/null 2>&1
end
