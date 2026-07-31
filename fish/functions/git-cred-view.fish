# View current GitHub credentials (username only, password hidden)
function git-cred-view
    security find-internet-password -s github.com 2>/dev/null | grep "acct" | string replace -r '.*"acct"<blob>="([^"]+)".*' '$1'
end
