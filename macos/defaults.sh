#!/usr/bin/env bash
# ============================================================
# macOS Defaults
# Configuración de preferencias del sistema
# ============================================================

set -euo pipefail

echo ""
echo "⚙️  Aplicando configuración de macOS..."
echo ""

# ------- Finder -------

# Mostrar archivos ocultos en Finder
defaults write com.apple.finder AppleShowAllFiles -bool true
echo "  ✅ Finder: archivos ocultos visibles"

# Mostrar extensiones de archivo siempre
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
echo "  ✅ Finder: extensiones de archivo visibles"

# ------- Trackpad -------

# Trackpad: activar click con un toque
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
echo "  ✅ Trackpad: tap-to-click activado"

# ------- Dock -------

# Dock: tamaño de iconos
defaults write com.apple.dock tilesize -int 48
echo "  ✅ Dock: tamaño de iconos = 48"

# Dock: posición abajo
defaults write com.apple.dock orientation -string "bottom"
echo "  ✅ Dock: posición = abajo"

# Dock: ocultación automática
defaults write com.apple.dock autohide -bool true
echo "  ✅ Dock: auto-hide activado"

# ------- Teclado -------

# Teclado: repetición rápida
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
echo "  ✅ Teclado: repetición rápida configurada"

# ------- Screenshots -------

# Guardar screenshots en una carpeta específica
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location "$HOME/Screenshots"
echo "  ✅ Screenshots: se guardarán en ~/Screenshots"

# ------- Reiniciar apps afectadas -------

echo ""
echo "🔄 Reiniciando Finder y Dock..."
killall Finder
killall Dock

echo ""
echo "✅ Configuración de macOS aplicada correctamente."
echo ""
