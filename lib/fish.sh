#!/usr/bin/env bash
# Fish config sync, Fisher plugins, and default shell

REPO_FISH_DIR="${REPO_ROOT}/fish"
FISH_CONFIG_DIR="${HOME}/.config/fish"

backup_file_if_changed() {
  local src="$1"
  local dest="$2"
  if [[ ! -f "$dest" ]]; then
    return 0
  fi
  if cmp -s "$src" "$dest"; then
    return 0
  fi
  local backup="${dest}.backup.$(date +%Y%m%d_%H%M%S)"
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would backup $dest → $backup"
    return 0
  fi
  cp "$dest" "$backup"
  warning "Backed up existing file to $backup"
}

sync_fish_templates() {
  info "Syncing Fish configuration templates..."

  if [[ ! -d "$REPO_FISH_DIR" ]]; then
    die "Missing fish templates at $REPO_FISH_DIR"
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would sync $REPO_FISH_DIR → $FISH_CONFIG_DIR"
    info "[dry-run] Would ensure conf.d/local.fish exists (without overwriting)"
    return 0
  fi

  mkdir -p "$FISH_CONFIG_DIR/functions" "$FISH_CONFIG_DIR/conf.d" "$FISH_CONFIG_DIR/completions"

  if [[ -f "$REPO_FISH_DIR/config.fish" ]]; then
    backup_file_if_changed "$REPO_FISH_DIR/config.fish" "$FISH_CONFIG_DIR/config.fish"
    cp "$REPO_FISH_DIR/config.fish" "$FISH_CONFIG_DIR/config.fish"
  fi

  if [[ -f "$REPO_FISH_DIR/fish_plugins" ]]; then
    cp "$REPO_FISH_DIR/fish_plugins" "$FISH_CONFIG_DIR/fish_plugins"
  fi

  if [[ -d "$REPO_FISH_DIR/functions" ]]; then
    local fn
    for fn in "$REPO_FISH_DIR/functions"/*.fish; do
      [[ -f "$fn" ]] || continue
      local base
      base="$(basename "$fn")"
      backup_file_if_changed "$fn" "$FISH_CONFIG_DIR/functions/$base"
      cp "$fn" "$FISH_CONFIG_DIR/functions/$base"
    done
  fi

  if [[ -d "$REPO_FISH_DIR/conf.d" ]]; then
    local conf
    for conf in "$REPO_FISH_DIR/conf.d"/*.fish; do
      [[ -f "$conf" ]] || continue
      local base
      base="$(basename "$conf")"
      # Never clobber machine-local secrets / env overrides
      if [[ "$base" == "local.fish" ]]; then
        continue
      fi
      backup_file_if_changed "$conf" "$FISH_CONFIG_DIR/conf.d/$base"
      cp "$conf" "$FISH_CONFIG_DIR/conf.d/$base"
    done
  fi

  ensure_fish_local_env

  success "Fish configuration synced"
}

# Create ~/.config/fish/conf.d/local.fish once; never overwrite on re-runs
ensure_fish_local_env() {
  local dest="$FISH_CONFIG_DIR/conf.d/local.fish"
  local src="$REPO_FISH_DIR/conf.d/local.fish"

  mkdir -p "$FISH_CONFIG_DIR/conf.d"

  if [[ -f "$dest" ]]; then
    info "Local env file already present (not overwritten): $dest"
    return 0
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would create $dest from template"
    return 0
  fi

  if [[ -f "$src" ]]; then
    cp "$src" "$dest"
  else
    cat >"$dest" <<'EOF'
# Local / private Fish environment variables (not managed by setup re-runs)
# Add: set -gx MY_VAR "value"
EOF
  fi

  success "Created local env file: $dest"
  info "Add secrets and machine-specific vars there, then run: reload"
}

install_fisher() {
  ensure_cmd fish || die "Fish is required but not installed"

  if [[ -f "$FISH_CONFIG_DIR/functions/fisher.fish" ]]; then
    success "Fisher already installed"
    return 0
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would install Fisher"
    return 0
  fi

  info "Installing Fisher..."
  fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
  success "Fisher installed"
}

install_fisher_plugins() {
  ensure_cmd fish || die "Fish is required but not installed"

  if [[ ! -f "$FISH_CONFIG_DIR/fish_plugins" ]]; then
    warning "No fish_plugins file found; skipping plugin install"
    return 0
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would install Fisher plugins from fish_plugins"
    return 0
  fi

  info "Installing Fisher plugins..."
  # fisher update reads fish_plugins and syncs installed set
  if fish -c 'type -q fisher; and fisher update'; then
    success "Fisher plugins up to date"
  else
    # Fallback: install each line
    while IFS= read -r plugin || [[ -n "$plugin" ]]; do
      [[ -z "$plugin" || "$plugin" =~ ^# ]] && continue
      info "Installing plugin: $plugin"
      fish -c "fisher install $plugin" || warning "Failed to install $plugin"
    done <"$FISH_CONFIG_DIR/fish_plugins"
    success "Fisher plugins installation completed"
  fi
}

set_fish_as_default_shell() {
  if [[ "${SKIP_SHELL:-0}" == "1" ]]; then
    info "Skipping default shell change (--skip-shell)"
    return 0
  fi

  local fish_path
  fish_path="$(command -v fish)" || die "Could not find Fish shell path"

  local current_shell
  current_shell="$(dscl . -read "/Users/$(whoami)" UserShell 2>/dev/null | awk '{print $2}')"

  if [[ "$current_shell" == "$fish_path" ]]; then
    success "Fish is already the default shell"
    return 0
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would set default shell to $fish_path (current: $current_shell)"
    return 0
  fi

  info "Current shell: $current_shell"
  info "Setting Fish as default: $fish_path"

  if ! grep -q "^${fish_path}$" /etc/shells 2>/dev/null; then
    info "Adding Fish to /etc/shells (requires sudo)..."
    if ! echo "$fish_path" | sudo tee -a /etc/shells >/dev/null; then
      warning "Could not update /etc/shells; skip default shell change"
      return 0
    fi
  fi

  if chsh -s "$fish_path"; then
    success "Fish set as default shell. Restart your terminal for changes to take effect."
  else
    warning "Could not change default shell (chsh failed). You can run: chsh -s $fish_path"
  fi
}
