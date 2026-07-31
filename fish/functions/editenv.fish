# Edit private Fish env vars (~/.config/fish/conf.d/local.fish)
function editenv
    set -l env_file ~/.config/fish/conf.d/local.fish

    if not test -f $env_file
        mkdir -p ~/.config/fish/conf.d
        printf '%s\n' \
            '# Local / private Fish environment variables' \
            '# Example: set -gx MY_VAR "value"' \
            '# After saving, run: reload' \
            '' >$env_file
    end

    $EDITOR $env_file
end
