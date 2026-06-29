#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

log_info "Setting up shell configuration..."

# Backup and symlink .zshrc
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" && "$BACKUP_EXISTING_CONFIGS" == true ]]; then
  mkdir -p "$BACKUP_DIR"
  cp "$HOME/.zshrc" "$BACKUP_DIR/.zshrc.backup"
  log_info "Backed up existing .zshrc"
fi
if [[ -f "$REPO_DIR/shell/.zshrc" ]]; then
  ln -sf "$REPO_DIR/shell/.zshrc" "$HOME/.zshrc"
  log_success "Linked .zshrc"
else
  log_warn "No .zshrc found in shell/ directory"
fi

# Backup and symlink .aliases
if [[ -f "$HOME/.aliases" && ! -L "$HOME/.aliases" && "$BACKUP_EXISTING_CONFIGS" == true ]]; then
  mkdir -p "$BACKUP_DIR"
  cp "$HOME/.aliases" "$BACKUP_DIR/.aliases.backup"
  log_info "Backed up existing .aliases"
fi
if [[ -f "$REPO_DIR/shell/.aliases" ]]; then
  ln -sf "$REPO_DIR/shell/.aliases" "$HOME/.aliases"
  log_success "Linked .aliases"
else
  log_warn "No .aliases found in shell/ directory"
fi
