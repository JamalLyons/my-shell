# Update Homebrew formulas + casks (apt-style convenience)
# Usage: brewup
function brewup
    if not type -q brew
        echo "Homebrew not found"
        return 1
    end

    echo "→ brew update"
    brew update
    or return $status

    echo "→ brew upgrade"
    brew upgrade
    or return $status

    echo "→ brew upgrade --cask"
    brew upgrade --cask
    or return $status

    echo "→ brew cleanup"
    brew cleanup

    if type -q fisher
        echo "→ fisher update"
        fisher update
    end

    echo "✓ Packages updated"
end
