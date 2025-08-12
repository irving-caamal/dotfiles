<file name=0 path=install.sh>#!/usr/bin/env bash
set -euo pipefail

# 1. Xcode command-line tools
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
fi

# 2. Homebrew & env
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(brew shellenv)"
brew update

# 3. Install CLI apps
brew install $(cat brew/apps.txt)

# 4. Install GUI casks
brew install --cask $(cat brew/casks.txt)

# 5. Nerd Font (Hack) for Powerlevel10k icons
brew install --cask font-hack-nerd-font

# 6. macOS defaults
sh "$(pwd)/macos/defaults.sh"

# 7. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 8. Symlink Zsh config & aliases
ln -sf "$(pwd)/shell/.zshrc"  "$HOME/.zshrc"
ln -sf "$(pwd)/shell/.aliases" "$HOME/.aliases"

# 9. Zsh plugins & theme
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true

git clone https://github.com/zsh-users/zsh-autosuggestions.git \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "$ZSH_CUSTOM/themes/powerlevel10k" 2>/dev/null || true

# 10. fzf keybindings & completion
"$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-bash --no-fish

# 11. asdf (Node & pnpm only; NO nvm)
brew install asdf
eval "$(brew shellenv)"

# Source asdf (Homebrew first, fallback to ~/.asdf)
if [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
  . "$(brew --prefix asdf)/libexec/asdf.sh"
elif [ -f "$HOME/.asdf/asdf.sh" ]; then
  . "$HOME/.asdf/asdf.sh"
else
  echo "❌  asdf not found; aborting."
  exit 1
fi

# ─ Node.js via asdf
asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || true
IMPORT_SCRIPT="$HOME/.asdf/plugins/nodejs/bin/import-release-team-keyring"
[ -x "$IMPORT_SCRIPT" ] && bash "$IMPORT_SCRIPT" || echo "⚠️  Skipping GPG import"
asdf install nodejs lts || true
asdf global nodejs lts 2>/dev/null || echo "⚠️  Could not set global Node.js"

# ─ pnpm via asdf
asdf plugin-add pnpm https://github.com/jonathanmorley/asdf-pnpm.git 2>/dev/null || true
asdf install pnpm latest || true
asdf global pnpm latest 2>/dev/null || echo "⚠️  Could not set global pnpm"

# 12. Global JS tools
pnpm install -g commitizen typescript eslint prettier || true

# 13. SSH: multiple GitHub keys (irveloper & irvv17)
sh "$(pwd)/ssh/setup-multi-github.sh"

echo "✔️  Done!"
</file>

<file name=setup-multi-github.sh path=ssh>#!/usr/bin/env bash
set -euo pipefail

# 13. SSH: multiple GitHub keys (irveloper & irvv17)
SSH_CONFIG="$HOME/.ssh/config"

if ! grep -q "Host github.com-irveloper" "$SSH_CONFIG" 2>/dev/null; then
  cat >> "$SSH_CONFIG" <<EOF

Host github.com-irveloper
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_irveloper
  IdentitiesOnly yes
EOF
fi

if ! grep -q "Host github.com-irvv17" "$SSH_CONFIG" 2>/dev/null; then
  cat >> "$SSH_CONFIG" <<EOF

Host github.com-irvv17
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_irvv17
  IdentitiesOnly yes
EOF
fi
</file>
