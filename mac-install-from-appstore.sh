#!/bin/zsh
# к этому моменту нужно войти в аккаунт в appstore
brew install mas

apps=(
  409183694 # Keynote
  409201541 # Pages
  409203825 # Numbers
  747648890 # Telegram
  310633997 # WhatsApp
  904280696 # Things 3
  1356178125 # Outline
  497799835 # Xcode
)

# Install apps
for app in "${apps[@]}"; do
  mas install $app
done

echo "Installation of apps from the Mac App Store is complete."
