#!/usr/bin/env bash
# fnm (Node) + pnpm/corepack setup

setup_fnm_node() {
  ensure_brew_on_path || true

  if ! ensure_cmd fnm; then
    die "fnm not found. Ensure it is listed in the Brewfile and brew bundle succeeded."
  fi

  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would run: fnm install --lts --use && fnm default lts-latest"
    return 0
  fi

  info "Installing Node.js LTS via fnm..."
  fnm install --lts --use
  # Alias LTS as the default for new shells
  fnm default lts-latest 2>/dev/null || fnm default "$(fnm current)"

  eval "$(fnm env --shell bash)"

  local version
  version="$(node --version 2>/dev/null || true)"
  if [[ -n "$version" ]]; then
    success "Node.js $version active via fnm"
  else
    warning "fnm install finished but node is not on PATH in this shell"
  fi
}

setup_pnpm() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    info "[dry-run] Would enable corepack / pnpm"
    return 0
  fi

  if ensure_cmd fnm; then
    eval "$(fnm env --shell bash)" 2>/dev/null || true
  fi

  if ! ensure_cmd corepack; then
    warning "corepack not found; skipping pnpm setup"
    return 0
  fi

  info "Enabling pnpm via Corepack..."
  corepack enable || warning "Failed to enable Corepack"
  corepack enable pnpm 2>/dev/null || corepack prepare pnpm@latest --activate 2>/dev/null || warning "Failed to enable pnpm"
  if ensure_cmd pnpm; then
    success "pnpm available: $(pnpm --version)"
  else
    warning "pnpm not on PATH yet; open a new Fish session after setup"
  fi
}
