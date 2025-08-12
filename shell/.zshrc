# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"

# Powerlevel10k theme (needs to be cloned first)
ZSH_THEME="powerlevel10k/powerlevel10k"
# Enable Nerd Font icons
POWERLEVEL9K_MODE="nerdfont-complete"

# Plugins per article
plugins=(
  git
  fzf
  zoxide
  zsh-syntax-highlighting
  zsh-autosuggestions
  bgnotify
)

source "$ZSH/oh-my-zsh.sh"

# Custom aliases (bonus round)
[ -f "$HOME/.aliases" ] && source "$HOME/.aliases"

# fzf keybindings & completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Initialize asdf
if command -v asdf &>/dev/null; then
  . "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Created by `pipx` on 2025-07-25 22:37:41
export PATH="$PATH:/Users/irveloper/.local/bin"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libxml2/lib/pkgconfig:$PKG_CONFIG_PATH"
export LDFLAGS="-L/opt/homebrew/opt/libiconv/lib $LDFLAGS"
export CPPFLAGS="-I/opt/homebrew/opt/libiconv/include $CPPFLAGS"
