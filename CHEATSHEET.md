# Terminal Cheatsheet

Quick reference for all keyboard shortcuts, plugins, aliases, and tools configured in this dotfiles setup.

---

## Hyper Key (Karabiner)

Caps Lock is remapped to a **Hyper Key** — hold it to activate 57 shortcuts across navigation, window management, and app launching. Tap it for Escape.

See **[karabiner/HYPER-KEY-GUIDE.md](karabiner/HYPER-KEY-GUIDE.md)** for the full visual guide with keyboard maps.

### Quick Reference

| Key | Action | | Key | Action |
|-----|--------|-|-----|--------|
| `H/J/K/L` | Arrow keys (vim) | | `V` | WebStorm |
| `A / ;` | Word left/right | | `T` | Warp |
| `U / O` | Line start/end | | `B` | Chrome |
| `I / N` | Page up/down | | `S` | Slack |
| `+ Shift` | Select (any nav key) | | `M` | Notion |
| `← → ↑ ↓` | Rectangle halves/max | | `1-7` | iTerm, Discord, Figma, GPT, Claude, Obsidian, Brave |
| `[ / ]` | Prev/next display | | `Space` | Raycast |
| `, . /` | Thirds (ultrawides) | | `X` | Lock screen |
| `- / =` | Smaller/larger | | `Y` | Clipboard history |
| `C` | Center window | | `\` | Screenshot |
| `Tab` | Mission Control | | `D/P/R/W/Z` | Dev shortcuts |

---

## Keyboard Shortcuts

### Fuzzy Finder (fzf)

| Shortcut | What it does |
|----------|-------------|
| `Ctrl+T` | Search files in current directory and paste the selection into the command line |
| `Ctrl+R` | Search command history with fuzzy matching (way better than default reverse search) |
| `Alt+C` | Fuzzy search directories and `cd` into the selected one |
| `Tab` | Dropdown completion menu (powered by fzf-tab) — type to filter, arrow keys to navigate |
| `<` / `>` | Switch between completion groups when using Tab completion |

### Autosuggestions (ghost text)

| Shortcut | What it does |
|----------|-------------|
| `→` (Right arrow) | Accept the full suggestion |
| `Ctrl+F` | Accept the full suggestion (alternative) |
| `Option+F` | Accept only the next word from the suggestion |
| `Ctrl+E` | Move to end of line (also accepts suggestion) |

### History Substring Search

| Shortcut | What it does |
|----------|-------------|
| `↑` (Up arrow) | Search history backwards — only shows commands matching what you already typed |
| `↓` (Down arrow) | Search history forwards — same filtered behavior |
| `Ctrl+P` | Same as Up arrow |
| `Ctrl+N` | Same as Down arrow |

**Example**: Type `git co` then press `↑` — only cycles through commands starting with `git co`.

### General Zsh

| Shortcut | What it does |
|----------|-------------|
| `Ctrl+A` | Move cursor to beginning of line |
| `Ctrl+E` | Move cursor to end of line |
| `Ctrl+W` | Delete word backwards |
| `Ctrl+U` | Delete entire line |
| `Ctrl+K` | Delete from cursor to end of line |
| `Ctrl+L` | Clear screen |
| `Option+←` | Move cursor one word left |
| `Option+→` | Move cursor one word right |
| `Ctrl+D` | Exit shell / delete character under cursor |

---

## Smart Tools

### zoxide — Smart `cd`

Learns your most-used directories and lets you jump to them with partial names.

```bash
z projects       # jumps to ~/Documents/projects (or wherever you go most)
z dotf           # jumps to ~/Documents/dotfiles
zi               # interactive selection with fzf
```

### fd — Fast File Finder

Faster alternative to `find`, respects `.gitignore`.

```bash
fd config              # find files matching "config"
fd -e tsx              # find all .tsx files
fd -e json -x cat {}   # find all .json files and cat them
```

### delta — Better Git Diffs

Automatically used by `git diff` — shows syntax-highlighted, side-by-side diffs.

### bat — Better `cat`

Aliased to `cat` — shows files with syntax highlighting and line numbers.

```bash
cat package.json       # syntax-highlighted output
bat -p file.txt        # plain mode (no line numbers)
```

### ripgrep (rg) — Better `grep`

Aliased to `grep` — searches file contents, respects `.gitignore`.

```bash
grep "useState"           # search all files for "useState"
grep "TODO" -t tsx         # search only .tsx files
grep "function" -l         # list files with matches only
```

---

## Aliases Quick Reference

### Navigation

| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `-` | `cd -` (previous directory) |

### File Listing

| Alias | Description |
|-------|-------------|
| `l` | Long list, human-readable sizes |
| `la` | Long list, show hidden files |
| `ll` | Long list |
| `lt` | Long list sorted by date |
| `tree` | Directory tree (via exa) |

### Git

| Alias | Command | Description |
|-------|---------|-------------|
| `gs` | `git status` | Status |
| `gss` | `git status -s` | Short status |
| `ga` | `git add` | Stage files |
| `gaa` | `git add --all` | Stage everything |
| `gc` | `git commit -v` | Commit with diff |
| `gcam` | `git commit -a -m` | Commit all with message |
| `gc!` | `git commit --amend` | Amend last commit |
| `gco` | `git checkout` | Checkout |
| `gcb` | `git checkout -b` | Create and switch branch |
| `gcm` | `git checkout main` | Switch to main |
| `gd` | `git diff` | Diff (with delta) |
| `gdca` | `git diff --cached` | Diff staged changes |
| `gl` | `git pull` | Pull |
| `gp` | `git push` | Push |
| `gb` | `git branch` | List branches |
| `gbd` | `git branch -d` | Delete branch |
| `grb` | `git rebase` | Rebase |
| `grbi` | `git rebase -i` | Interactive rebase |
| `gst` | `git stash` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |
| `gstl` | `git stash list` | List stashes |
| `glog` | `git log --oneline --graph` | Pretty log |
| `glol` | Decorated graph log | Detailed pretty log |
| `grt` | `cd` to repo root | Jump to git root |

### Docker

| Alias | Command |
|-------|---------|
| `d` | `docker` |
| `dc` | `docker-compose` |
| `dcu` | `docker-compose up` |
| `dcd` | `docker-compose down` |
| `dce` | `docker-compose exec` |
| `dcl` | `docker-compose logs` |

### Package Managers

**pnpm** (`p`):

| Alias | Command |
|-------|---------|
| `pi` | `pnpm install` |
| `pa` | `pnpm add` |
| `pad` | `pnpm add --save-dev` |
| `pd` | `pnpm dev` |
| `pb` | `pnpm build` |
| `pt` | `pnpm test` |
| `pl` | `pnpm lint` |

**yarn** (`y`):

| Alias | Command |
|-------|---------|
| `yi` | `yarn install` |
| `ya` | `yarn add` |
| `yad` | `yarn add --dev` |
| `yd` | `yarn dev` |
| `yb` | `yarn build` |
| `yt` | `yarn test` |

**npm** (`n`):

| Alias | Command |
|-------|---------|
| `ni` | `npm install` |
| `nr` | `npm run` |
| `ns` | `npm start` |
| `nt` | `npm test` |

### Editor

| Alias | Command |
|-------|---------|
| `v` / `vi` / `vim` | `nvim` |
| `e` | `$EDITOR` |
| `zshconfig` | Edit `~/.zshrc` |
| `aliasconfig` | Edit `~/.aliases` |
| `reload` | `source ~/.zshrc` |

### Utilities

| Alias / Command | What it does |
|-----------------|-------------|
| `mkcd dirname` | Create directory and cd into it |
| `extract file` | Extract any archive (.zip, .tar.gz, .7z, etc.) |
| `weather` | Show weather in terminal |
| `myip` | Show your public IP |
| `path` | Show PATH entries, one per line |
| `flushdns` | Flush DNS cache (macOS) |
| `showfiles` / `hidefiles` | Toggle hidden files in Finder |

### Safety Aliases

`rm`, `cp`, `mv` all ask for confirmation before overwriting. This is intentional.

---

## Plugin Summary

| Plugin | What it does | Installed via |
|--------|-------------|---------------|
| **zsh-autosuggestions** | Ghost text from history as you type | `brew` |
| **zsh-syntax-highlighting** | Green = valid command, red = invalid | `brew` |
| **zsh-history-substring-search** | Up/Down arrows filter history by what you typed | `brew` |
| **fzf-tab** | Replaces Tab completion with a fuzzy dropdown | git clone |
| **fzf** | Fuzzy finder for files, history, directories | `brew` |
| **zoxide** | Smart `cd` that learns your habits | `brew` |
| **delta** | Syntax-highlighted git diffs | `brew` |

---

## Local Customization

Machine-specific config goes in these files (not tracked by git):

- `~/.zshrc.local` — extra PATH entries, env vars, machine-specific shell config
- `~/.aliases.local` — machine-specific aliases
