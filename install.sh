#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
export REPO_DIR
cd "$REPO_DIR"

# Source configuration
if [[ -f "$REPO_DIR/config.sh" ]]; then
  source "$REPO_DIR/config.sh"
else
  echo "Warning: config.sh not found. Using default values."
  LOG_FILE="$HOME/.dotfiles-install.log"
  BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  BACKUP_EXISTING_CONFIGS=true
  log_info() { echo "[INFO] $*"; }
  log_warn() { echo "[WARN] $*"; }
  log_error() { echo "[ERROR] $*"; }
  log_success() { echo "[SUCCESS] $*"; }
fi

export BACKUP_DIR

log_info "Starting dotfiles installation..."
log_info "Repository directory: $REPO_DIR"
log_info "Log file: $LOG_FILE"

# Create backup directory if needed
if [[ "$BACKUP_EXISTING_CONFIGS" == true ]]; then
  mkdir -p "$BACKUP_DIR"
  log_info "Created backup directory: $BACKUP_DIR"
fi

# Run each step in order
STEPS=(
  "scripts/xcode.sh"
  "scripts/brew.sh"
  "scripts/asdf.sh"
  "scripts/zsh-plugins.sh"
  "scripts/symlinks.sh"
  "scripts/npm.sh"
  "scripts/karabiner.sh"
)

for step in "${STEPS[@]}"; do
  if [[ -f "$REPO_DIR/$step" ]]; then
    bash "$REPO_DIR/$step"
  else
    log_warn "Script not found: $step"
  fi
done

# SSH multi-GitHub setup (existing standalone script)
if [[ "$SKIP_SSH_SETUP" != true ]]; then
  log_info "Setting up SSH keys for GitHub..."
  if [[ -f "$REPO_DIR/ssh/setup-multi-github.sh" ]]; then
    bash "$REPO_DIR/ssh/setup-multi-github.sh" || log_warn "SSH setup encountered issues"
  else
    log_warn "SSH setup script not found at ssh/setup-multi-github.sh"
  fi
else
  log_info "Skipping SSH setup (SKIP_SSH_SETUP=true)"
fi

# macOS defaults (existing standalone script)
if [[ "$SKIP_MACOS_DEFAULTS" != true && "${OSTYPE:-}" == darwin* ]]; then
  log_info "Applying macOS system preferences..."
  if [[ -f "$REPO_DIR/macos/defaults.sh" ]]; then
    bash "$REPO_DIR/macos/defaults.sh" || log_warn "Some macOS defaults failed to apply"
    log_success "macOS defaults applied"
  else
    log_warn "macOS defaults script not found at macos/defaults.sh"
  fi
else
  if [[ "$SKIP_MACOS_DEFAULTS" == true ]]; then
    log_info "Skipping macOS defaults (SKIP_MACOS_DEFAULTS=true)"
  else
    log_info "Skipping macOS defaults (not on macOS)"
  fi
fi

log_success "Dotfiles installation completed!"
log_info "Log file saved to: $LOG_FILE"
if [[ "$BACKUP_EXISTING_CONFIGS" == true ]]; then
  log_info "Backups saved to: $BACKUP_DIR"
fi
echo ""
echo "Done! Restart your terminal to load shell changes."
