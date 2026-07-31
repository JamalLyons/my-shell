# ============================================================================
# Local / private Fish environment variables
# ============================================================================
#
# WHY THIS FILE EXISTS
#   setup.sh installs a shared Fish config from the my-shell repo. Secrets and
#   machine-specific values must NOT live in that shared config (or in git).
#   This file is the place for those values. Fish auto-loads every *.fish file
#   in conf.d/ for each session.
#
# GIT
#   The copy in the repo is intentionally empty of secrets — comments only.
#   setup.sh creates ~/.config/fish/conf.d/local.fish from this template on
#   first run and will NEVER overwrite it on later runs.
#
# AFTER SETUP
#   Edit:  ~/.config/fish/conf.d/local.fish
#   Then:  reload   (or open a new Fish tab)
#
# EXAMPLES (uncomment and fill in):
#
# set -gx GOOGLE_CLOUD_PROJECT your-gcp-project-id
# set -gx NPM_TOKEN ""
# fish_add_path $HOME/.antigravity/antigravity/bin
# fish_add_path /usr/local/mysql/bin
#
# ============================================================================
