#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

log_info "Setting up Karabiner-Elements configuration..."
KARABINER_CONFIG_DIR="$HOME/.config/karabiner"

if [[ -f "$REPO_DIR/karabiner/karabiner.json" ]]; then
  mkdir -p "$KARABINER_CONFIG_DIR"
  if [[ -f "$KARABINER_CONFIG_DIR/karabiner.json" && ! -L "$KARABINER_CONFIG_DIR/karabiner.json" && "$BACKUP_EXISTING_CONFIGS" == true ]]; then
    mkdir -p "$BACKUP_DIR"
    cp "$KARABINER_CONFIG_DIR/karabiner.json" "$BACKUP_DIR/karabiner.json.backup"
    log_info "Backed up existing karabiner.json"
  fi
  # NOTE: Karabiner 15.7+ can't read config through symlinks -- must copy
  cp -f "$REPO_DIR/karabiner/karabiner.json" "$KARABINER_CONFIG_DIR/karabiner.json"
  log_success "Copied karabiner.json (Hyper Key configuration)"
else
  log_warn "No karabiner.json found in karabiner/ directory"
fi
