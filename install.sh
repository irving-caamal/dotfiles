#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

# Source configuration
if [[ -f "$REPO_DIR/config.sh" ]]; then
  source "$REPO_DIR/config.sh"
else
  echo "⚠️  Warning: config.sh not found. Using default values."
  LOG_FILE="$HOME/.dotfiles-install.log"
  BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  BACKUP_EXISTING_CONFIGS=true
  log_info() { echo "[INFO] $*"; }
  log_warn() { echo "[WARN] $*"; }
  log_error() { echo "[ERROR] $*"; }
  log_success() { echo "[SUCCESS] $*"; }
fi

log_info "Starting dotfiles installation..."
log_info "Repository directory: $REPO_DIR"
log_info "Log file: $LOG_FILE"

# 0) Create backup directory if needed
if [[ "$BACKUP_EXISTING_CONFIGS" == true ]]; then
  mkdir -p "$BACKUP_DIR"
  log_info "Created backup directory: $BACKUP_DIR"
fi

# 1) Ensure Xcode CLT on macOS (no-op elsewhere)
log_info "Checking for Xcode Command Line Tools..."
if [[ "${OSTYPE:-}" == darwin* ]]; then
  if ! xcode-select -p >/dev/null 2>&1; then
    log_warn "Xcode Command Line Tools not found. Installing..."
    xcode-select --install || log_warn "Failed to install Xcode CLT. Please install manually."
  else
    log_success "Xcode Command Line Tools already installed"
  fi
fi

# 2) Homebrew (macOS only)
log_info "Setting up Homebrew..."
if [[ "${OSTYPE:-}" == darwin* ]]; then
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
      [[ "$app" =~ ^[[:space:]]*# ]] && continue  # Skip comments
      [[ -z "$app" ]] && continue  # Skip empty lines
      app=$(echo "$app" | xargs)  # Trim whitespace
      if brew list "$app" &>/dev/null; then
        log_info "✓ $app already installed"
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
      [[ "$cask" =~ ^[[:space:]]*# ]] && continue  # Skip comments
      [[ -z "$cask" ]] && continue  # Skip empty lines
      cask=$(echo "$cask" | xargs)  # Trim whitespace
      if brew list --cask "$cask" &>/dev/null; then
        log_info "✓ $cask already installed"
      else
        log_info "Installing $cask..."
        brew install --cask "$cask" || log_warn "Failed to install $cask"
      fi
    done < "$REPO_DIR/brew/casks.txt"
  elif [[ "$SKIP_BREW_CASKS" == true ]]; then
    log_info "Skipping GUI applications (SKIP_BREW_CASKS=true)"
  fi
else
  log_warn "Skipping Homebrew setup (not on macOS)"
fi

# 3) asdf setup (optional; safe if not installed)
if [[ "$SKIP_ASDF_SETUP" != true ]]; then
  log_info "Setting up asdf version manager..."
  if command -v asdf >/dev/null 2>&1; then
    log_info "Adding Node.js plugin to asdf..."
    asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || log_info "Node.js plugin already exists"
    
    if [[ -f "$REPO_DIR/asdf/.tool-versions" ]]; then
      if [[ "$BACKUP_EXISTING_CONFIGS" == true && -f "$HOME/.tool-versions" ]]; then
        cp "$HOME/.tool-versions" "$BACKUP_DIR/.tool-versions.backup"
        log_info "Backed up existing .tool-versions"
      fi
      cp "$REPO_DIR/asdf/.tool-versions" "$HOME/.tool-versions"
      log_info "Copied .tool-versions to home directory"
      log_info "Installing tools from .tool-versions..."
      asdf install || log_warn "Some tools failed to install"
      log_success "asdf setup completed"
    else
      log_warn "No .tool-versions file found in asdf/"
    fi
  else
    log_warn "asdf not found. Install via Homebrew first: brew install asdf"
  fi
else
  log_info "Skipping asdf setup (SKIP_ASDF_SETUP=true)"
fi

# 4) Shell dotfiles (symlink)
log_info "Setting up shell configuration..."
mkdir -p "$HOME"

# Backup and symlink .zshrc
if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" && "$BACKUP_EXISTING_CONFIGS" == true ]]; then
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
  cp "$HOME/.aliases" "$BACKUP_DIR/.aliases.backup"
  log_info "Backed up existing .aliases"
fi
if [[ -f "$REPO_DIR/shell/.aliases" ]]; then
  ln -sf "$REPO_DIR/shell/.aliases" "$HOME/.aliases"
  log_success "Linked .aliases"
else
  log_warn "No .aliases found in shell/ directory"
fi

# 5) Global JS tools (if package manager available)
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

# 6) SSH multi-GitHub setup
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

# 7) macOS defaults (optional)
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
echo "✔️  Done! Restart your terminal to load shell changes."