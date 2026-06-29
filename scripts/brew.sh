#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${REPO_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$REPO_DIR/config.sh"

log_info "Setting up Homebrew..."
if [[ "${OSTYPE:-}" != darwin* ]]; then
  log_warn "Skipping Homebrew setup (not on macOS)"
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  log_info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    log_error "Failed to install Homebrew"
    exit 1
  }
  eval "$((/opt/homebrew/bin/brew shellenv) 2>/dev/null || (/usr/local/bin/brew shellenv))"
  log_success "Homebrew installed successfully"
else
  log_info "Homebrew found. Updating..."
  brew update || log_warn "Failed to update Homebrew"
fi

# Install CLI apps
if [[ -f "$REPO_DIR/brew/apps.txt" ]]; then
  log_info "Installing CLI applications from brew/apps.txt..."
  while IFS= read -r app; do
    [[ "$app" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$app" ]] && continue
    app=$(echo "$app" | xargs)
    if brew list "$app" &>/dev/null; then
      log_info "$app already installed"
    else
      log_info "Installing $app..."
      brew install "$app" || log_warn "Failed to install $app"
    fi
  done < "$REPO_DIR/brew/apps.txt"
fi

# Install casks
if [[ -f "$REPO_DIR/brew/casks.txt" && "$SKIP_BREW_CASKS" != true ]]; then
  log_info "Installing GUI applications from brew/casks.txt..."
  while IFS= read -r cask; do
    [[ "$cask" =~ ^[[:space:]]*# ]] && continue
    [[ -z "$cask" ]] && continue
    cask=$(echo "$cask" | xargs)
    if brew list --cask "$cask" &>/dev/null; then
      log_info "$cask already installed"
    else
      log_info "Installing $cask..."
      brew install --cask "$cask" || log_warn "Failed to install $cask"
    fi
  done < "$REPO_DIR/brew/casks.txt"
elif [[ "$SKIP_BREW_CASKS" == true ]]; then
  log_info "Skipping GUI applications (SKIP_BREW_CASKS=true)"
fi
