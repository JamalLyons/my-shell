# Flush the macOS DNS cache
function flushdns
    sudo dscacheutil -flushcache
    and sudo killall -HUP mDNSResponder
    and echo "DNS cache flushed"
end
