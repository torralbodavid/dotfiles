#!/usr/bin/env bash
# ============================================================
# 🚀 Dotfiles Installer
# Clona el repo → ejecuta este script → Mac listo para trabajar
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
BREWFILE_TMP="$DOTFILES_DIR/Brewfile.tmp"

# -------------------------------------------------------
# Colores
# -------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# -------------------------------------------------------
# Helpers
# -------------------------------------------------------
info()    { echo -e "${BLUE}ℹ️  $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $1${NC}"; }
ask()     { echo -e "${CYAN}❓ $1${NC}"; }

ask_yes_no() {
    local prompt="$1"
    local default="$2"  # "y" o "n"
    local answer

    if [[ "$default" == "y" ]]; then
        ask "$prompt [Y/n]"
    else
        ask "$prompt [y/N]"
    fi

    read -r answer
    answer="${answer:-$default}"
    [[ "$answer" =~ ^[Yy]$ ]]
}

# -------------------------------------------------------
# Banner
# -------------------------------------------------------
echo ""
echo -e "${BOLD}${CYAN}"
echo "  ╔══════════════════════════════════════════╗"
echo "  ║        🚀 Dotfiles Installer             ║"
echo "  ║     Configura tu Mac en un solo paso     ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# -------------------------------------------------------
# 1. Instalar Homebrew si no está instalado
# -------------------------------------------------------
if ! command -v brew &>/dev/null; then
    info "Homebrew no encontrado. Instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Añadir Homebrew al PATH para Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    success "Homebrew instalado"
else
    success "Homebrew ya está instalado"
fi

echo ""
brew update
success "Homebrew actualizado"
echo ""

# -------------------------------------------------------
# 2. Preguntas interactivas — Apps opcionales
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   📦 Configuración de aplicaciones${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# --- API Client: Postman o Insomnia ---
ask "¿Qué cliente de APIs prefieres? [1] Postman (default) / [2] Insomnia"
read -r api_client_choice
api_client_choice="${api_client_choice:-1}"

if [[ "$api_client_choice" == "2" ]]; then
    API_CLIENT="insomnia"
    info "Se instalará Insomnia"
else
    API_CLIENT="postman"
    info "Se instalará Postman"
fi
echo ""

# --- Notion ---
if ask_yes_no "¿Instalar Notion?" "y"; then
    INSTALL_NOTION=true
    info "Se instalará Notion"
else
    INSTALL_NOTION=false
    warn "Notion no se instalará"
fi
echo ""

# --- Rectangle ---
if ask_yes_no "¿Instalar Rectangle (gestor de ventanas)?" "y"; then
    INSTALL_RECTANGLE=true
    info "Se instalará Rectangle"
else
    INSTALL_RECTANGLE=false
    warn "Rectangle no se instalará"
fi
echo ""

# --- Sequel Ace ---
if ask_yes_no "¿Instalar Sequel Ace (cliente MySQL)?" "y"; then
    INSTALL_SEQUEL_ACE=true
    info "Se instalará Sequel Ace"
else
    INSTALL_SEQUEL_ACE=false
    warn "Sequel Ace no se instalará"
fi
echo ""

# --- Warp ---
if ask_yes_no "¿Instalar Warp (terminal moderno)?" "y"; then
    INSTALL_WARP=true
    info "Se instalará Warp"
else
    INSTALL_WARP=false
    warn "Warp no se instalará"
fi
echo ""

# --- FileZilla (manual, no disponible en Homebrew) ---
if ask_yes_no "¿Quieres que se abra la web de FileZilla para descargarlo manualmente? (ya no está en Homebrew)" "n"; then
    OPEN_FILEZILLA=true
    info "Se abrirá la web de FileZilla al final"
else
    OPEN_FILEZILLA=false
fi
echo ""

# --- Google Chrome Canary ---
if ask_yes_no "¿Instalar Google Chrome Canary?" "n"; then
    INSTALL_CHROME_CANARY=true
    info "Se instalará Chrome Canary"
else
    INSTALL_CHROME_CANARY=false
    warn "Chrome Canary no se instalará"
fi
echo ""

# -------------------------------------------------------
# 3. Generar Brewfile dinámico
# -------------------------------------------------------
info "Generando Brewfile personalizado..."

cp "$BREWFILE" "$BREWFILE_TMP"

# Añadir API Client
echo "cask \"$API_CLIENT\"" >> "$BREWFILE_TMP"

# Añadir opcionales
[[ "$INSTALL_NOTION" == true ]]       && echo 'cask "notion"'              >> "$BREWFILE_TMP"
[[ "$INSTALL_RECTANGLE" == true ]]    && echo 'cask "rectangle"'           >> "$BREWFILE_TMP"
[[ "$INSTALL_SEQUEL_ACE" == true ]]   && echo 'cask "sequel-ace"'          >> "$BREWFILE_TMP"
[[ "$INSTALL_WARP" == true ]]         && echo 'cask "warp"'                >> "$BREWFILE_TMP"
[[ "$INSTALL_CHROME_CANARY" == true ]] && echo 'cask "google-chrome@canary"' >> "$BREWFILE_TMP"

success "Brewfile personalizado generado"
echo ""

# -------------------------------------------------------
# 4. Instalar apps con Homebrew Bundle
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🍺 Instalando aplicaciones con Homebrew${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

brew bundle --file="$BREWFILE_TMP" --verbose

# Limpiar Brewfile temporal
rm -f "$BREWFILE_TMP"

success "Todas las aplicaciones instaladas"
echo ""

# -------------------------------------------------------
# 5. Configuración de Git
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🔧 Configuración de Git${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

ask "¿Cuál es tu nombre completo para Git? (ej: David Torralbo)"
read -r GIT_NAME

ask "¿Cuál es tu email para Git? (ej: dtorralbo@gnahs.com)"
read -r GIT_EMAIL

# Generar .gitconfig
cat > "$DOTFILES_DIR/configs/.gitconfig" <<EOF
[core]
	excludesFile = $HOME/.gitignore_global
[user]
	name = $GIT_NAME
	email = $GIT_EMAIL
EOF

success ".gitconfig generado para $GIT_NAME <$GIT_EMAIL>"
echo ""

# -------------------------------------------------------
# 6. Crear symlinks
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🔗 Creando symlinks${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# .zshrc
if [[ -f "$HOME/.zshrc" ]]; then
    warn "Ya existe ~/.zshrc — se hará backup en ~/.zshrc.backup"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -sf "$DOTFILES_DIR/configs/.zshrc" "$HOME/.zshrc"
success "~/.zshrc → dotfiles/configs/.zshrc"

# .gitconfig
if [[ -f "$HOME/.gitconfig" ]]; then
    warn "Ya existe ~/.gitconfig — se hará backup en ~/.gitconfig.backup"
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
fi
ln -sf "$DOTFILES_DIR/configs/.gitconfig" "$HOME/.gitconfig"
success "~/.gitconfig → dotfiles/configs/.gitconfig"

# .gitignore_global
if [[ -f "$HOME/.gitignore_global" ]]; then
    warn "Ya existe ~/.gitignore_global — se hará backup en ~/.gitignore_global.backup"
    cp "$HOME/.gitignore_global" "$HOME/.gitignore_global.backup"
fi
ln -sf "$DOTFILES_DIR/configs/.gitignore_global" "$HOME/.gitignore_global"
success "~/.gitignore_global → dotfiles/configs/.gitignore_global"

echo ""

# -------------------------------------------------------
# 7. Aplicar configuración de macOS
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🍎 Aplicando configuración de macOS${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

bash "$DOTFILES_DIR/macos/defaults.sh"

# -------------------------------------------------------
# 8. FileZilla (descarga manual)
# -------------------------------------------------------
if [[ "$OPEN_FILEZILLA" == true ]]; then
    echo ""
    info "Abriendo web de FileZilla para descarga manual..."
    open "https://filezilla-project.org/download.php?platform=osx"
fi

# -------------------------------------------------------
# 9. Recargar shell
# -------------------------------------------------------
echo ""
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🎉 ¡Instalación completada!${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${GREEN}•${NC} Aplicaciones instaladas via Homebrew"
echo -e "  ${GREEN}•${NC} Git configurado para ${BOLD}$GIT_NAME${NC}"
echo -e "  ${GREEN}•${NC} Aliases y funciones en ~/.zshrc"
echo -e "  ${GREEN}•${NC} Preferencias de macOS aplicadas"
echo -e "  ${GREEN}•${NC} Screenshots se guardarán en ~/Screenshots"
echo ""
echo -e "${CYAN}Ejecuta ${BOLD}source ~/.zshrc${NC}${CYAN} o abre una nueva terminal para cargar los aliases.${NC}"
echo ""
