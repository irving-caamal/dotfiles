#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

log_info "Installing global JavaScript packages..."
if command -v pnpm >/dev/null 2>&1; then
  log_info "Using pnpm to install global packages..."
  for package in "${GLOBAL_NPM_PACKAGES[@]}"; do
    log_info "Installing $package..."
    pnpm install -g "$package" || log_warn "Failed to install $package"
  done
elif command -v npm >/dev/null 2>&1; then
  log_info "Using npm to install global packages..."
  for package in "${GLOBAL_NPM_PACKAGES[@]}"; do
    log_info "Installing $package..."
    npm install -g "$package" || log_warn "Failed to install $package"
  done
else
  log_warn "No package manager (pnpm/npm) found. Skipping global packages."
fi
