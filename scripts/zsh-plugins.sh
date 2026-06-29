#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

log_info "Setting up fzf-tab plugin..."
if [[ -d "$HOME/.zsh/fzf-tab" ]]; then
  log_info "fzf-tab already installed, updating..."
  git -C "$HOME/.zsh/fzf-tab" pull --quiet || log_warn "Failed to update fzf-tab"
else
  log_info "Cloning fzf-tab..."
  mkdir -p "$HOME/.zsh"
  git clone https://github.com/Aloxaf/fzf-tab "$HOME/.zsh/fzf-tab" || log_warn "Failed to clone fzf-tab"
fi
