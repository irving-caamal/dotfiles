# Personal Dotfiles

Automated macOS developer setup. One command installs everything — Homebrew, CLI tools, GUI apps, shell plugins, SSH keys, Karabiner shortcuts, and macOS preferences.

---

## What gets installed

| Category | Tools |
|---|---|
| Shell | zsh-autosuggestions, zsh-syntax-highlighting, zsh-history-substring-search, fzf-tab |
| CLI | git, neovim, fzf, tmux, asdf, gh, zoxide, delta, fd, tree, bat, eza, ripgrep, lazygit, watchman, mas |
| Node.js | asdf-managed Node 20, global: commitizen, typescript, eslint, prettier |
| GUI apps | iTerm2, Raycast, VSCode, Cursor, Windsurf, 1Password, Docker, TablePlus, Figma, Warp, and more |
| Config | Karabiner Hyper Key (57 shortcuts), SSH multi-account (2 GitHub identities), macOS defaults |

---

## New Mac setup

### 1. Install Xcode Command Line Tools

Open **Terminal** and run:

```bash
git
```

macOS will prompt you to install Xcode Command Line Tools. Click **Install** and wait (~5 min). Do not skip this — Homebrew requires it.

### 2. Clone this repo

```bash
git clone https://github.com/irveloper/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Run the installer

```bash
chmod +x install.sh
./install.sh
```

The installer runs these steps in order:

| Step | What it does |
|---|---|
| `xcode.sh` | Waits for Xcode CLT if not yet installed |
| `brew.sh` | Installs Homebrew, then all packages from `brew/apps.txt` and `brew/casks.txt` |
| `asdf.sh` | Sets up asdf, installs Node.js from `.tool-versions` |
| `zsh-plugins.sh` | Clones fzf-tab into `~/.zsh/fzf-tab` |
| `symlinks.sh` | Symlinks `.zshrc` and `.aliases` into `~` |
| `npm.sh` | Installs global npm/pnpm packages |
| `karabiner.sh` | Copies Hyper Key config to `~/.config/karabiner` |
| SSH setup | Generates ed25519 keys for both GitHub accounts, writes `~/.ssh/config` |
| macOS defaults | Applies system preferences (key repeat, hidden files, save panel) |

> First-time install takes 15–30 min depending on internet speed. All steps are idempotent — safe to re-run.

Backups of any existing configs are saved to `~/.dotfiles-backup-<timestamp>/`.

### 4. Add SSH keys to GitHub

After the installer finishes, it prints your public keys. Add them to GitHub:

**Primary account** (`irveloper@gmail.com`):
```bash
cat ~/.ssh/id_ed25519_github_irveloper.pub | pbcopy
```
Go to [GitHub → Settings → SSH keys → New SSH key](https://github.com/settings/ssh/new) and paste.

**Secondary account** (`irvv.17@gmail.com`):
```bash
cat ~/.ssh/id_ed25519_github_irvv17.pub | pbcopy
```
Log into your secondary GitHub account and repeat.

Test both connections:
```bash
ssh -T git@github-irveloper
ssh -T git@github-irvv17
# Expected: "Hi <username>! You've successfully authenticated..."
```

### 5. Restart terminal

Close and reopen Terminal (or open iTerm2/Warp). All shell changes load on a fresh session.

### 6. Verify

```bash
git --version
nvim --version
node --version
fzf --version
asdf --version
zoxide --version
```

---

## Usage guide

### Git with two GitHub accounts

Each account gets its own SSH host alias. Use them in your remote URLs:

```bash
# Clone with primary account (irveloper)
git clone git@github-irveloper:username/repo.git

# Clone with secondary account (irvv17)
git clone git@github-irvv17:username/repo.git

# Change an existing remote to use a specific identity
git remote set-url origin git@github-irveloper:username/repo.git
```

### Smart directory jumping (zoxide)

zoxide learns your most-visited directories. After a few days it replaces `cd`.

```bash
z projects        # jump to ~/projects (or wherever you go most)
z dot             # fuzzy match — jumps to ~/dotfiles
zi                # interactive picker with fzf
```

### Fuzzy search (fzf)

| Shortcut | Action |
|---|---|
| `Ctrl+T` | Fuzzy file picker — inserts path at cursor |
| `Ctrl+R` | Fuzzy history search |
| `Alt+C` | Fuzzy cd into a subdirectory |
| `Tab` on any command | Dropdown completion via fzf-tab |

### Shell plugins

| Plugin | What it does |
|---|---|
| zsh-autosuggestions | Ghost text from history — press `→` to accept |
| zsh-syntax-highlighting | Commands turn green/red as you type |
| zsh-history-substring-search | Type partial command, `↑/↓` to filter history |

### Key aliases

**Navigation**
```bash
..        # cd ..
...       # cd ../..
~         # cd ~
-         # cd - (previous directory)
```

**Files**
```bash
l         # ls -lFh
la        # ls -lAFh (show hidden)
ll        # ls -l
v / vim   # nvim
```

**Git**
```bash
g         # git
gs        # git status
ga        # git add
gaa       # git add --all
gc        # git commit -v
gcm       # git checkout main
gcb       # git checkout -b
gd        # git diff
gl        # git pull
gp        # git push
glog      # git log --oneline --decorate --graph
gst       # git stash
gstp      # git stash pop
grt       # cd to repo root
```

**Node / pnpm**
```bash
p         # pnpm
pi        # pnpm install
pd        # pnpm dev
pb        # pnpm build
pt        # pnpm test
```

**Docker**
```bash
d         # docker
dc        # docker-compose
dcu       # docker-compose up
dcd       # docker-compose down
```

**System**
```bash
reload      # source ~/.zshrc
zshconfig   # open .zshrc in nvim
aliasconfig # open .aliases in nvim
myip        # print public IP
weather     # curl wttr.in (terminal weather)
flushdns    # flush macOS DNS cache
```

**Custom shell functions**
```bash
mkcd <dir>          # mkdir + cd in one step
extract <file>      # extract any archive format
warp [dir]          # open Warp terminal at path
```

---

## Customization

### Before first install — edit `config.sh`

```bash
# Your GitHub emails
GITHUB_EMAIL_PRIMARY="you@gmail.com"
GITHUB_EMAIL_SECONDARY="you-work@company.com"

# SSH host aliases (used in git remote URLs)
GITHUB_HOST_PRIMARY="github-personal"
GITHUB_HOST_SECONDARY="github-work"

# Skip flags
SKIP_BREW_CASKS=false       # true = skip GUI app installs
SKIP_SSH_SETUP=false        # true = skip SSH key generation
SKIP_MACOS_DEFAULTS=false   # true = skip system preferences
```

### Machine-specific config (not tracked by git)

Create `~/.zshrc.local` for secrets, work paths, or machine-only env vars. It loads automatically at the end of `.zshrc`:

```bash
# ~/.zshrc.local
export GITHUB_TOKEN="ghp_..."
export PATH="/work/internal/bin:$PATH"
export AWS_PROFILE="production"
```

Same pattern for aliases — create `~/.aliases.local`:

```bash
# ~/.aliases.local
alias work='cd ~/work/main-repo'
alias vpn='sudo openconnect vpn.company.com'
```

### Add/remove Homebrew packages

```bash
# Add CLI tool
echo "httpie" >> brew/apps.txt

# Add GUI app
echo "obsidian" >> brew/casks.txt

# Remove (comment out)
sed -i '' 's/^yarn$/#yarn/' brew/apps.txt
```

Then re-run `./install.sh` — it skips already-installed packages.

### Change Node.js version

Edit `asdf/.tool-versions`:
```
nodejs 22.0.0
```

Then run:
```bash
asdf install
asdf global nodejs 22.0.0
```

### Add more macOS defaults

Edit `macos/defaults.sh`. Find available keys at [macos-defaults.com](https://macos-defaults.com):

```bash
# Three-finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Dock auto-hide
defaults write com.apple.dock autohide -bool true && killall Dock
```

---

## Keeping dotfiles up to date

```bash
cd ~/dotfiles
git pull origin main
./install.sh          # re-run is safe and idempotent
```

To update all Homebrew packages separately:

```bash
brew update && brew upgrade
```

---

## Project structure

```
dotfiles/
├── install.sh                   # Entry point — run this
├── config.sh                    # Personal config (emails, flags, skip options)
├── brew/
│   ├── apps.txt                 # CLI tools
│   └── casks.txt                # GUI apps
├── shell/
│   ├── .zshrc                   # Zsh config
│   └── .aliases                 # All aliases
├── git/
│   ├── .gitconfig               # Git config with delta, sensible defaults
│   └── .gitignore_global        # Global gitignore (applied to all repos)
├── asdf/
│   └── .tool-versions           # Runtime versions
├── karabiner/
│   ├── karabiner.json           # Hyper Key config
│   └── HYPER-KEY-GUIDE.md       # All 57 shortcuts with diagrams
├── ssh/
│   └── setup-multi-github.sh    # Multi-account SSH setup
├── macos/
│   └── defaults.sh              # System preferences
└── scripts/
    ├── xcode.sh
    ├── brew.sh
    ├── asdf.sh
    ├── zsh-plugins.sh
    ├── symlinks.sh
    ├── npm.sh
    └── karabiner.sh
```

---

## Troubleshooting

**Xcode CLT dialog appeared but installer kept going**
Re-run `./install.sh` after CLT finishes installing. The script now waits, but if you ran an older version it may not have.

**`brew: command not found` after install**
Homebrew on Apple Silicon installs to `/opt/homebrew`. Run:
```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```
This is already in `.zshrc`, so a terminal restart fixes it permanently.

**`command not found: node` after install**
asdf shims are loaded via `.zshrc`. Restart terminal or run:
```bash
exec zsh
node --version
```

**SSH: `Permission denied (publickey)`**
```bash
ssh-add -l                                    # check agent has your keys
ssh-add ~/.ssh/id_ed25519_github_irveloper    # re-add if missing
ssh -T git@github-irveloper                   # test
```

**Shell plugins not working (no autosuggestions, no syntax highlight)**
```bash
brew install zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search
exec zsh
```

**Karabiner not applying shortcuts**
Karabiner-Elements needs Accessibility and Input Monitoring permissions.
Go to **System Settings → Privacy & Security** and enable both for Karabiner-Elements.

**Re-run a single step**
Each script is standalone:
```bash
bash scripts/brew.sh
bash scripts/symlinks.sh
bash ssh/setup-multi-github.sh
```

---

## Requirements

- macOS (Apple Silicon or Intel)
- Admin account
- Internet connection
- ~5 GB free disk space (for apps)
