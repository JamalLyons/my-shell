# Update GitHub credentials
# Usage: git-cred-update <username> <personal-access-token>
function git-cred-update
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

    git-cred-clear

    git config --global credential.helper osxkeychain

    echo "protocol=https
host=github.com
username=$username
password=$token" | git credential approve

    echo "GitHub credentials updated!"
    echo "Username: $username"
end
