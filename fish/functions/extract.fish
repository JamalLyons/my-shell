# Extract various archive formats
function extract
    if test -z "$argv[1]"
        echo "Usage: extract <archive>"
        return 1
    end

    set file $argv[1]
    if test ! -f $file
        echo "Error: $file not found"
        return 1
    end

    switch $file
        case "*.tar.gz" "*.tgz"
            tar -xzf $file
        case "*.tar.bz2" "*.tbz2"
            tar -xjf $file
        case "*.tar.xz"
            tar -xJf $file
        case "*.tar"
            tar -xf $file
        case "*.zip"
            unzip $file
        case "*.rar"
            unrar x $file
        case "*.7z"
            7z x $file
        case "*.gz"
            gunzip $file
        case "*.bz2"
            bunzip2 $file
        case "*"
            echo "Unknown archive format: $file"
            return 1
    end
end
