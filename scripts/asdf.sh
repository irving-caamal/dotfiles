#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

if [[ "$SKIP_ASDF_SETUP" == true ]]; then
  log_info "Skipping asdf setup (SKIP_ASDF_SETUP=true)"
  exit 0
fi

log_info "Setting up asdf version manager..."

# Homebrew may have just been installed — ensure its bin is in PATH
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v asdf >/dev/null 2>&1; then
  log_warn "asdf not found even after Homebrew PATH setup. Make sure brew.sh ran first."
  exit 0
fi

log_info "Adding Node.js plugin to asdf..."
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || log_info "Node.js plugin already exists"

if [[ -f "$REPO_DIR/asdf/.tool-versions" ]]; then
  if [[ "$BACKUP_EXISTING_CONFIGS" == true && -f "$HOME/.tool-versions" ]]; then
    mkdir -p "$BACKUP_DIR"
    cp "$HOME/.tool-versions" "$BACKUP_DIR/.tool-versions.backup"
    log_info "Backed up existing .tool-versions"
  fi
  ln -sf "$REPO_DIR/asdf/.tool-versions" "$HOME/.tool-versions"
  log_info "Linked .tool-versions to home directory"
  log_info "Installing tools from .tool-versions..."
  asdf install || log_warn "Some tools failed to install"
  log_success "asdf setup completed"
else
  log_warn "No .tool-versions file found in asdf/"
fi
