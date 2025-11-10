# ============================================================================
# Fish Shell Configuration for macOS
# ============================================================================

# ----------------------------------------------------------------------------
# Environment Variables & Path Setup
# ----------------------------------------------------------------------------

# Add common macOS paths if they exist
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

if test -d /opt/homebrew/sbin
    fish_add_path /opt/homebrew/sbin
end

# Add local bin directory
if test -d ~/.local/bin
    fish_add_path ~/.local/bin
end

# Configure nvm.fish to use existing ~/.nvm directory
# This must be set before conf.d/nvm.fish loads
if test -d ~/.nvm
    set -gx nvm_data ~/.nvm
end

# Set default Node version to load automatically on startup
# This will use the default alias (which points to stable)
# You can change this to a specific version like "v25.1.0" if preferred
if not set -q nvm_default_version
    set -Ux nvm_default_version default
end

# Set default editor (prefer Cursor, then zed, then vim)
if type -q cursor
    set -gx EDITOR cursor
else if type -q zed
    set -gx EDITOR zed
else if type -q vim
    set -gx EDITOR vim
else if type -q nano
    set -gx EDITOR nano
else
    set -gx EDITOR vi
end
set -gx VISUAL $EDITOR

# macOS specific settings
if test (uname) = "Darwin"
    # Disable Apple's zsh warning
    set -gx BASH_SILENCE_DEPRECATION_WARNING 1
    
    # Use Homebrew's curl if available
    if test -f /opt/homebrew/bin/curl
        set -gx PATH /opt/homebrew/bin $PATH
    end
end

# ----------------------------------------------------------------------------
# Fish Shell Settings
# ----------------------------------------------------------------------------

# Better history
set -gx fish_history_size 10000

# Disable greeting
set -g fish_greeting ""

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------

# General
alias ll "ls -lah"
alias la "ls -la"
alias l "ls -l"
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."

# macOS specific
alias showfiles "defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hidefiles "defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"
alias cleanup "find . -type f -name '*.DS_Store' -ls -delete"

# Git shortcuts
alias gs "git status"
alias ga "git add"
alias gc "git commit -m"
alias gp "git push"
alias gl "git log --oneline --graph --decorate --all"
alias gd "git diff"
alias gb "git branch"
alias gco "git checkout"
alias gst "git stash"
alias gsp "git stash pop"

# Development
alias beep "echo -e '\a'"
alias ports "lsof -i -P -n | grep LISTEN"
alias myip "curl -s https://ipinfo.io/ip"
alias weather "curl -s 'wttr.in?format=3'"

# Docker (if installed)
if command -v docker >/dev/null
    alias d "docker"
    alias dc "docker compose"
    alias dps "docker ps"
    alias dpa "docker ps -a"
    alias di "docker images"
    alias dex "docker exec -it"
end

# ----------------------------------------------------------------------------
# Abbreviations (auto-expand)
# ----------------------------------------------------------------------------

abbr -a -- gst git status
abbr -a -- gco git checkout
abbr -a -- gaa git add --all
abbr -a -- gcm git commit -m
abbr -a -- gps git push
abbr -a -- gpl git pull
abbr -a -- gd git diff
abbr -a -- gl git log --oneline --graph --decorate --all

# ----------------------------------------------------------------------------
# Custom Functions
# ----------------------------------------------------------------------------

# Create directory and cd into it
function mkcd
    mkdir -p $argv[1]
    cd $argv[1]
end

# Extract various archive formats
function extract
    if test -z $argv[1]
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

# Find files by name
function ff
    find . -name "*$argv[1]*" -type f
end

# Find directories by name
function fd
    find . -name "*$argv[1]*" -type d
end

# Quick search in files
function grep
    command grep --color=auto $argv
end

# Show disk usage of current directory
function duh
    du -h -d 1 | sort -hr
end

# Quick server (Python)
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

# Quick note taking
function note
    set note_file ~/.notes
    if test (count $argv) -gt 0
        echo (date "+%Y-%m-%d %H:%M:%S") "|" $argv >> $note_file
        echo "Note added: $argv"
    else
        if test -f $note_file
            cat $note_file
        else
            echo "No notes yet. Add one with: note 'your note here'"
        end
    end
end

# Git credential management helpers
function git-cred-clear
    # Clear GitHub credentials from keychain
    security delete-internet-password -s github.com 2>/dev/null
    echo "GitHub credentials cleared from keychain"
end

function git-cred-update
    # Update GitHub credentials
    # Usage: git-cred-update <username> <personal-access-token>
    if test (count $argv) -lt 2
        echo "Usage: git-cred-update <username> <personal-access-token>"
        echo ""
        echo "To create a Personal Access Token:"
        echo "  1. Go to: https://github.com/settings/tokens"
        echo "  2. Generate new token (classic)"
        echo "  3. Select scopes: repo, workflow, write:packages, delete:packages"
        return 1
    end
    
    set username $argv[1]
    set token $argv[2]
    
    # Clear old credentials
    git-cred-clear
    
    # Set up credential helper
    git config --global credential.helper osxkeychain
    
    # Store new credentials via git credential helper
    echo "protocol=https
host=github.com
username=$username
password=$token" | git credential approve
    
    echo "GitHub credentials updated!"
    echo "Username: $username"
end

function git-cred-view
    # View current GitHub credentials (username only, password hidden)
    security find-internet-password -s github.com 2>/dev/null | grep "acct" | string replace -r '.*"acct"<blob>="([^"]+)".*' '$1'
end

# Show help for custom commands
function helpme
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "  Fish Shell Custom Commands & Ureltilities"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "  Configuration:"
    echo "    reload         - Reload fish configuration"
    echo "    editfish       - Open fish config in editor"
    echo ""
    echo "  File Operations:"
    echo "    mkcd <dir>     - Create directory and cd into it"
    echo "    extract <file> - Extract various archive formats"
    echo "    ff <name>      - Find files by name"
    echo "    fd <name>      - Find directories by name"
    echo "    duh            - Show disk usage of current directory"
    echo ""
    echo "  Development:"
    echo "    serve [port]   - Start HTTP server (default: 8000)"
    echo "    ports          - Show listening ports"
    echo "    myip           - Show your public IP"
    echo "    weather        - Show weather"
    echo ""
    echo "  Utilities:"
    echo "    note [text]    - Add/view notes"
    echo "    cleanup        - Remove .DS_Store files"
    echo ""
    echo "  Git Credentials:"
    echo "    git-cred-clear           - Clear GitHub credentials from keychain"
    echo "    git-cred-update <user> <token> - Update GitHub credentials"
    echo "    git-cred-view            - View current GitHub username"
    echo ""
    echo "  Git Abbreviations (type and press space to expand):"
    echo "    gst            - git status"
    echo "    gco            - git checkout"
    echo "    gaa            - git add --all"
    echo "    gcm            - git commit -m"
    echo "    gps            - git push"
    echo "    gpl            - git pull"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end

# ----------------------------------------------------------------------------
# Interactive Session Setup
# ----------------------------------------------------------------------------

if status is-interactive
    # Welcome message (only show once per session)
    if not set -q FISH_WELCOME_SHOWN
        set -gx FISH_WELCOME_SHOWN 1
        # Uncomment the line below if you want a welcome message
        # echo "🐟 Fish shell ready! Type 'helpme' for custom commands."
    end
end