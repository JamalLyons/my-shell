# Clear GitHub credentials from keychain
function git-cred-clear
    security delete-internet-password -s github.com 2>/dev/null
    echo "GitHub credentials cleared from keychain"
end
