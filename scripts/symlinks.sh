#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

log_info "Setting up shell and git configuration..."

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

# Backup and symlink .gitconfig
if [[ -f "$HOME/.gitconfig" && ! -L "$HOME/.gitconfig" && "$BACKUP_EXISTING_CONFIGS" == true ]]; then
  mkdir -p "$BACKUP_DIR"
  cp "$HOME/.gitconfig" "$BACKUP_DIR/.gitconfig.backup"
  log_info "Backed up existing .gitconfig"
fi
if [[ -f "$REPO_DIR/git/.gitconfig" ]]; then
  ln -sf "$REPO_DIR/git/.gitconfig" "$HOME/.gitconfig"
  log_success "Linked .gitconfig"
else
  log_warn "No .gitconfig found in git/ directory"
fi

# Symlink global .gitignore
if [[ -f "$REPO_DIR/git/.gitignore_global" ]]; then
  ln -sf "$REPO_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
  log_success "Linked .gitignore_global"
fi
