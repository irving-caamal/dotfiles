# ~/.zshrc - Zsh configuration

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History configuration
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

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select

# Homebrew setup (Apple Silicon and Intel)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# asdf version manager
if [[ -f "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh" ]]; then
  source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"
elif [[ -f "$HOME/.asdf/asdf.sh" ]]; then
  source "$HOME/.asdf/asdf.sh"
fi

# fzf fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  # Setup fzf key bindings and completion
  if [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
  fi
  if [[ -f "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh" ]]; then
    source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
  fi
  
  # fzf configuration
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'head -100 {}'"
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# zoxide smart directory jumper
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Load aliases
if [[ -f ~/.aliases ]]; then
  source ~/.aliases
fi

# Git prompt function
git_prompt_info() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git branch --show-current 2>/dev/null)
    local status=""
    
    # Check for changes
    if ! git diff --quiet 2>/dev/null; then
      status+="*"
    fi
    
    # Check for staged changes
    if ! git diff --cached --quiet 2>/dev/null; then
      status+="+"
    fi
    
    # Check for untracked files
    if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
      status+="?"
    fi
    
    if [[ -n $status ]]; then
      echo " (%{$fg[yellow]%}${branch}${status}%{$reset_color%})"
    else
      echo " (%{$fg[green]%}${branch}%{$reset_color%})"
    fi
  fi
}

# Enable colors
autoload -U colors && colors

# Custom prompt (simple and clean)
setopt PROMPT_SUBST
PROMPT='%{$fg[cyan]%}%~%{$reset_color%}$(git_prompt_info) %{$fg[white]%}$ %{$reset_color%}'

# Environment variables
export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-R"

# Node.js configuration
export NODE_OPTIONS="--max-old-space-size=4096"

# Go configuration (if installed)
if command -v go >/dev/null 2>&1; then
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# Python configuration
export PYTHONPATH="$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH"

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Custom functions
mkcd() {
  mkdir -p "$1" && cd "$1"
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

# Load local customizations (if exists)
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi