#!/usr/bin/env bash
set -euo pipefail

# Multi-account GitHub SSH setup (irveloper & irvv17)
# - Generates keys if missing
# - Adds them to ssh-agent (uses Keychain on macOS)
# - Creates idempotent ~/.ssh/config hosts

# --- config ---
EMAIL1="irveloper@gmail.com"
EMAIL2="irvv.17@gmail.com"
HOST1="github-irveloper"
HOST2="github-irvv17"
KEY1_NAME="id_ed25519_github_irveloper"
KEY2_NAME="id_ed25519_github_irvv17"

# --- prepare ~/.ssh ---
SSH_DIR="$HOME/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
CONFIG="$SSH_DIR/config"
: > /dev/null # noop for clarity

KEY1="$SSH_DIR/$KEY1_NAME"
KEY2="$SSH_DIR/$KEY2_NAME"

# --- generate keys if missing ---
if [[ ! -f "$KEY1" ]]; then
  ssh-keygen -t ed25519 -C "$EMAIL1" -f "$KEY1" -N ""
fi
if [[ ! -f "$KEY2" ]]; then
  ssh-keygen -t ed25519 -C "$EMAIL2" -f "$KEY2" -N ""
fi
chmod 600 "$KEY1" "$KEY2"
chmod 644 "$KEY1.pub" "$KEY2.pub"

# --- start/prepare agent and add keys ---
if [[ -z "${SSH_AUTH_SOCK:-}" ]]; then
  eval "$(ssh-agent -s)" >/dev/null
fi
if [[ "${OSTYPE:-}" == darwin* ]]; then
  # Store passphrases in Apple Keychain if applicable
  ssh-add --apple-use-keychain "$KEY1" || true
  ssh-add --apple-use-keychain "$KEY2" || true
else
  ssh-add "$KEY1" || true
  ssh-add "$KEY2" || true
fi

# --- write ~/.ssh/config entries idempotently ---
create_host_block() {
  local host="$1" key_path="$2"
  cat <<EOF
Host ${host}
  HostName github.com
  User git
  IdentityFile ${key_path}
  IdentitiesOnly yes
  AddKeysToAgent yes
  IgnoreUnknown UseKeychain
  UseKeychain yes

EOF
}

touch "$CONFIG"
chmod 600 "$CONFIG"

# only append if exact Host line is missing (prevents duplicates)
if ! grep -qE "^Host[[:space:]]+${HOST1}$" "$CONFIG"; then
  create_host_block "$HOST1" "$KEY1" >> "$CONFIG"
fi
if ! grep -qE "^Host[[:space:]]+${HOST2}$" "$CONFIG"; then
  create_host_block "$HOST2" "$KEY2" >> "$CONFIG"
fi

# --- info for the user ---
echo ""
echo "🔑 Public keys ready. Add them in GitHub → Settings → SSH and GPG keys:"
echo "   • ${EMAIL1} → ${KEY1}.pub"
echo "   • ${EMAIL2} → ${KEY2}.pub"

echo ""
echo "✅ SSH config hosts created: ${HOST1}, ${HOST2}"
echo "   Test: ssh -T git@${HOST1}  |  ssh -T git@${HOST2}"

echo ""
echo "💡 Use these remotes to clone/push with the right identity:"
echo "   git clone git@${HOST1}:USER_OR_ORG/REPO.git"
echo "   git clone git@${HOST2}:USER_OR_ORG/REPO.git"