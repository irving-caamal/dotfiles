#!/usr/bin/env bash

# Configuration file for dotfiles setup
# Customize these variables to match your preferences

# --- Personal Information ---
GITHUB_EMAIL_PRIMARY="irveloper@gmail.com"
GITHUB_EMAIL_SECONDARY="irvv.17@gmail.com"
GITHUB_HOST_PRIMARY="github-irveloper"
GITHUB_HOST_SECONDARY="github-irvv17"

# --- SSH Key Configuration ---
SSH_KEY_PRIMARY="id_ed25519_github_irveloper"
SSH_KEY_SECONDARY="id_ed25519_github_irvv17"

# --- Development Tools ---
# Global npm packages to install (if pnpm/npm is available)
GLOBAL_NPM_PACKAGES=(
  "commitizen"
  "typescript"
  "eslint"
  "prettier"
)

# --- Logging Configuration ---
LOG_LEVEL="INFO"  # DEBUG, INFO, WARN, ERROR
LOG_FILE="$HOME/.dotfiles-install.log"

# --- Installation Options ---
SKIP_BREW_CASKS=false         # Set to true to skip GUI applications
SKIP_ASDF_SETUP=false         # Set to true to skip asdf version manager
SKIP_SSH_SETUP=false          # Set to true to skip SSH key generation
SKIP_MACOS_DEFAULTS=false     # Set to true to skip macOS system preferences
BACKUP_EXISTING_CONFIGS=true  # Create backups of existing dotfiles

# --- Backup Directory ---
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# --- Colors for Output ---
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export WHITE='\033[0;37m'
export NC='\033[0m' # No Color

# --- Helper Functions ---
log_debug() { [[ "$LOG_LEVEL" == "DEBUG" ]] && echo -e "${PURPLE}[DEBUG]${NC} $*" | tee -a "$LOG_FILE"; }
log_info() { [[ "$LOG_LEVEL" =~ ^(DEBUG|INFO)$ ]] && echo -e "${BLUE}[INFO]${NC} $*" | tee -a "$LOG_FILE"; }
log_warn() { [[ "$LOG_LEVEL" =~ ^(DEBUG|INFO|WARN)$ ]] && echo -e "${YELLOW}[WARN]${NC} $*" | tee -a "$LOG_FILE"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOG_FILE"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*" | tee -a "$LOG_FILE"; }

# Initialize log file
mkdir -p "$(dirname "$LOG_FILE")"
echo "# Dotfiles installation log - $(date)" >> "$LOG_FILE"