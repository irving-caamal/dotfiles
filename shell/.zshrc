# ~/.zshrc - Zsh configuration

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Homebrew (must be early — plugins depend on brew --prefix) ───────────
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ── History ──────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# ── Directory navigation ────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# ── Completion system ───────────────────────────────────────────────────
autoload -Uz compinit
compinit -C

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''

# ── fzf-tab (Warp-like dropdown completions — must be after compinit) ───
if [[ -f ~/.zsh/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath 2>/dev/null'
  zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color=always $realpath 2>/dev/null'
  zstyle ':fzf-tab:complete:*:*' fzf-preview 'echo $desc'
  zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse --border
  zstyle ':fzf-tab:*' switch-group '<' '>'
fi

# ── asdf version manager ────────────────────────────────────────────────
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
if [[ -f "/opt/homebrew/opt/asdf/share/zsh/site-functions/_asdf" ]]; then
  fpath=(/opt/homebrew/opt/asdf/share/zsh/site-functions $fpath)
fi

# ── fzf fuzzy finder ────────────────────────────────────────────────────
if command -v fzf >/dev/null 2>&1; then
  if [[ -f "${HOMEBREW_PREFIX:-}/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
  fi
  if [[ -f "${HOMEBREW_PREFIX:-}/opt/fzf/shell/completion.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
  fi
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'head -100 {}'"
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ── zoxide (smart cd) ───────────────────────────────────────────────────
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# ── Aliases ──────────────────────────────────────────────────────────────
if [[ -f ~/.aliases ]]; then
  source ~/.aliases
fi

# ── Prompt ───────────────────────────────────────────────────────────────
autoload -U colors && colors

git_prompt_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    local git_status=""
    if ! git diff --quiet 2>/dev/null; then
      git_status+="*"
    fi
    if ! git diff --cached --quiet 2>/dev/null; then
      git_status+="+"
    fi
    if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
      git_status+="?"
    fi
    if [[ -n $git_status ]]; then
      echo " (%{$fg[yellow]%}${branch}${git_status}%{$reset_color%})"
    else
      echo " (%{$fg[green]%}${branch}%{$reset_color%})"
    fi
  fi
}

setopt PROMPT_SUBST
PROMPT='%{$fg[cyan]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[white]%}$ %{$reset_color%}'

# ── Environment variables ───────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"
export NODE_OPTIONS="--max-old-space-size=4096"
export PATH="$HOME/.local/bin:$PATH"

if command -v go >/dev/null 2>&1; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# ── Custom functions ────────────────────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

warp() {
  local target_dir="${1:-.}"
  open -a Warp "$target_dir"
}

extract() {
  if [[ -f $1 ]]; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ── Warp-like plugins (order matters!) ──────────────────────────────────

# 1. Syntax highlighting (colors commands as you type)
if [[ -f "${HOMEBREW_PREFIX:-}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# 2. Autosuggestions (ghost text from history)
if [[ -f "${HOMEBREW_PREFIX:-}/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#888888"
  ZSH_AUTOSUGGEST_STRATEGY=(history)
fi

# 3. History substring search (type partial command, arrow up/down to filter)
if [[ -f "${HOMEBREW_PREFIX:-}/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source "$HOMEBREW_PREFIX/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=black,bold'
  HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
fi

# ── Local overrides (machine-specific paths, tools, etc.) ───────────────
# Put machine-specific config in ~/.zshrc.local (not tracked by dotfiles)
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

