# ============================================================================
# Fish Shell Configuration for macOS
# Managed by my-shell — edit templates in the repo, then re-run setup.sh
# ============================================================================

# ----------------------------------------------------------------------------
# Environment Variables & Path Setup
# ----------------------------------------------------------------------------

# Set TERM to enable icons and colors (required for Tide prompt)
# Only set if TERM is not already set or is set to 'dumb'
if not set -q TERM; or test "$TERM" = dumb
    if test (uname) = Darwin
        set -gx TERM xterm-256color
    else
        set -gx TERM xterm-256color
    end
end

# Homebrew (Apple Silicon and Intel)
if test -d /opt/homebrew/bin
    fish_add_path /opt/homebrew/bin
end

if test -d /opt/homebrew/sbin
    fish_add_path /opt/homebrew/sbin
end

if test -d /usr/local/bin
    fish_add_path /usr/local/bin
end

if test -d ~/.local/bin
    fish_add_path ~/.local/bin
end

if test -d ~/.cargo/bin
    fish_add_path ~/.cargo/bin
end

# rustup via Homebrew (keg-only)
if test -d /opt/homebrew/opt/rustup/bin
    fish_add_path /opt/homebrew/opt/rustup/bin
else if test -d /usr/local/opt/rustup/bin
    fish_add_path /usr/local/opt/rustup/bin
end

# Default editor (prefer zed, then cursor, then vim)
if type -q zed
    set -gx EDITOR zed
else if type -q cursor
    set -gx EDITOR cursor
else if type -q vim
    set -gx EDITOR vim
else if type -q nano
    set -gx EDITOR nano
else
    set -gx EDITOR vi
end
set -gx VISUAL $EDITOR

# macOS specific settings
if test (uname) = Darwin
    set -gx BASH_SILENCE_DEPRECATION_WARNING 1
end

# ----------------------------------------------------------------------------
# Fish Shell Settings
# ----------------------------------------------------------------------------

set -gx fish_history_size 10000
set -g fish_greeting ""

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------

alias ll "ls -lah"
alias la "ls -la"
alias l "ls -l"
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."

# Prefer eza when available
if type -q eza
    alias ll "eza -lah --group-directories-first"
    alias la "eza -la --group-directories-first"
    alias l "eza -l --group-directories-first"
end

# Prefer bat for cat when available
if type -q bat
    alias cat bat
end

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
alias cls "clear"

# Docker (if installed)
if command -v docker >/dev/null
    alias d docker
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
# Interactive Session Setup
# ----------------------------------------------------------------------------

if status is-interactive
    if not set -q FISH_WELCOME_SHOWN
        set -gx FISH_WELCOME_SHOWN 1
        echo "🐟 Fish shell ready! Type 'helpme' for custom commands."
    end

    # zoxide (smart cd) when available
    if type -q zoxide
        zoxide init fish | source
    end

    # fzf key bindings / completion when available
    if type -q fzf
        fzf --fish | source
    end
end

# pnpm
set -gx PNPM_HOME "$HOME/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end

# bun
if test -d "$HOME/.bun"
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
end
