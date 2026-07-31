# cd to the frontmost Finder window
function cdf
    set -l target (osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as alias)' 2>/dev/null)
    if test -z "$target"
        echo "No Finder window open"
        return 1
    end
    cd $target
end
