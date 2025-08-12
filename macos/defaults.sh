#!/usr/bin/env bash
# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder
# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Expand save panel
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
