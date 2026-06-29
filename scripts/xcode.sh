#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

log_info "Checking for Xcode Command Line Tools..."
if [[ "${OSTYPE:-}" == darwin* ]]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    log_warn "Xcode Command Line Tools not found. Installing..."
    xcode-select --install || log_warn "Failed to install Xcode CLT. Please install manually."
  else
    log_success "Xcode Command Line Tools already installed"
  fi
fi
