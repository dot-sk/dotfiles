#!/bin/bash

# This script sets up a development environment on macOS.
# It installs Homebrew, Oh My Zsh, various applications and tools,
# and configures Zsh and Git with basic settings.

# Install Homebrew, the macOS package manager
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Oh My Zsh, a framework for managing your Zsh configuration
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Tap the Homebrew cask fonts repository to install fonts
brew tap homebrew/cask-fonts

# Install applications and tools using Homebrew
# This includes development tools, productivity software, and fonts
brew install --cask \
  warp \
  visual-studio-code \
  zoom \
  rectangle \
  hiddenbar \
  docker \
  font-jetbrains-mono \
  obsidian \
  yandex-disk \
  vlc \
  shottr \
  spotify \
  eqmac \
  figma

# Change ownership of /usr/local/bin to the current user
# This is necessary for managing local binaries without using sudo
sudo chown -R $(whoami) /usr/local/bin

# Create a symlink for Visual Studio Code in /usr/local/bin
# This allows you to launch VS Code from the command line using 'code'
ln -s "$(brew --prefix)/bin/code" /usr/local/bin/code

# Create a symlink for WebStorm in /usr/local/bin
# This allows you to launch WebStorm from the command line using 'ws'
ln -s /Applications/WebStorm.app/Contents/MacOS/webstorm /usr/local/bin/ws

# Install command-line tools using Homebrew
# These tools include ffmpeg, wget, and more, for various development needs
brew install ffmpeg wget fnm pure imagemagick ssh-copy-id jq

# Configure fnm, fast Node.js version management, to use on directory change
echo 'eval "$(fnm env --use-on-cd)"' >> $HOME/.zshrc

# Add the path to Zsh functions to the Zsh configuration
echo "fpath+=($(brew --prefix)/share/zsh/site-functions)" >> $HOME/.zshrc

# Set up the 'pure' prompt for Zsh, providing a minimal and informative prompt
echo "autoload -U promptinit; promptinit" >> $HOME/.zshrc
echo "prompt pure" >> $HOME/.zshrc

# Add an alias for 'npm run' to simplify npm commands
echo 'alias nr="npm run"' >> ~/.zshrc

# Configure Git with user information
git config --global user.name "Сергей Хохлачев"
git config --global user.email s.s.khokhlachev@tinkoff.ru

