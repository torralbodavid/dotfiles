#!/usr/bin/env bash
# ============================================================
# macOS Defaults
# System preferences configuration
# ============================================================

set -euo pipefail

echo ""
echo "⚙️  Applying macOS configuration..."
echo ""

# ------- Finder -------

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
echo "  ✅ Finder: hidden files are now visible"

# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo "  ✅ Finder: file extensions are now visible"

# ------- Trackpad -------

# Trackpad: tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
echo "  ✅ Trackpad: tap-to-click enabled"

# ------- Dock -------

# Dock: icon size
defaults write com.apple.dock tilesize -int 48
echo "  ✅ Dock: icon size set to 48"

# Dock: position bottom
defaults write com.apple.dock orientation -string "bottom"
echo "  ✅ Dock: position set to bottom"

# Dock: auto-hide
defaults write com.apple.dock autohide -bool true
echo "  ✅ Dock: auto-hide enabled"

# ------- Keyboard -------

# Keyboard: fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo "  ✅ Keyboard: fast repeat rate configured"

# ------- Battery -------

# Show battery percentage in the menu bar
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
echo "  ✅ Battery: percentage is now visible"

# ------- Screenshots -------

# Save screenshots to a specific folder
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location "$HOME/Screenshots"
echo "  ✅ Screenshots: will be saved to ~/Screenshots"

# ------- Restart affected apps -------

echo ""
echo "🔄 Restarting System UI..."
killall Finder
killall Dock
killall SystemUIServer
killall ControlCenter

echo ""
echo "✅ macOS configuration successfully applied."
echo ""
