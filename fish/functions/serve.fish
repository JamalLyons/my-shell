# Quick HTTP server (Python)
function serve
    if test -n "$argv[1]"
        set port $argv[1]
    else
        set port 8000
    end
    if command -v python3 >/dev/null
        python3 -m http.server $port
    else if command -v python >/dev/null
        python -m SimpleHTTPServer $port
    else
        echo "Python not found"
        return 1
    end
end
