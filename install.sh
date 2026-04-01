#!/usr/bin/env bash
# ============================================================
# 🚀 Dotfiles Installer
# Clones the repo → runs this script → Mac ready to work
# ============================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
BREWFILE_TMP="$DOTFILES_DIR/Brewfile.tmp"

# -------------------------------------------------------
# Colors
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
    local default="$2"  # "y" or "n"
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
echo "  ║     Setup your Mac in a single step      ║"
echo "  ╚══════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# -------------------------------------------------------
# Execution Mode
# -------------------------------------------------------
if ask_yes_no "Do you want to ONLY apply macOS configuration (skip all app installations and git config)?" "n"; then
    echo ""
    info "Running ONLY macOS configuration..."
    bash "$DOTFILES_DIR/macos/defaults.sh"
    echo ""
    success "Done! Exiting."
    exit 0
fi
echo ""

# -------------------------------------------------------
# 1. Install Homebrew if not installed
# -------------------------------------------------------
if ! command -v brew &>/dev/null; then
    info "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    success "Homebrew installed"
else
    success "Homebrew is already installed"
fi

echo ""
brew update
success "Homebrew updated"
echo ""

# -------------------------------------------------------
# 2. Interactive questions — Optional apps
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   📦 Application configuration${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# --- API Client: Postman or Insomnia ---
ask "Which API client do you prefer? [1] Postman (default) / [2] Insomnia"
read -r api_client_choice
api_client_choice="${api_client_choice:-1}"

if [[ "$api_client_choice" == "2" ]]; then
    API_CLIENT="insomnia"
    info "Insomnia will be installed"
else
    API_CLIENT="postman"
    info "Postman will be installed"
fi
echo ""

# --- Notion ---
if ask_yes_no "Install Notion?" "y"; then
    INSTALL_NOTION=true
    info "Notion will be installed"
else
    INSTALL_NOTION=false
    warn "Notion will not be installed"
fi
echo ""

# --- Rectangle ---
if ask_yes_no "Install Rectangle (window manager)?" "y"; then
    INSTALL_RECTANGLE=true
    info "Rectangle will be installed"
else
    INSTALL_RECTANGLE=false
    warn "Rectangle will not be installed"
fi
echo ""

# --- Sequel Ace ---
if ask_yes_no "Install Sequel Ace (MySQL client)?" "y"; then
    INSTALL_SEQUEL_ACE=true
    info "Sequel Ace will be installed"
else
    INSTALL_SEQUEL_ACE=false
    warn "Sequel Ace will not be installed"
fi
echo ""

# --- Warp ---
if ask_yes_no "Install Warp (modern terminal)?" "y"; then
    INSTALL_WARP=true
    info "Warp will be installed"
else
    INSTALL_WARP=false
    warn "Warp will not be installed"
fi
echo ""



# --- Google Chrome Canary ---
if ask_yes_no "Install Google Chrome Canary?" "n"; then
    INSTALL_CHROME_CANARY=true
    info "Chrome Canary will be installed"
else
    INSTALL_CHROME_CANARY=false
    warn "Chrome Canary will not be installed"
fi
echo ""

# -------------------------------------------------------
# 3. Generate dynamic Brewfile
# -------------------------------------------------------
info "Generating custom Brewfile..."

cp "$BREWFILE" "$BREWFILE_TMP"

# Add API Client
echo "cask \"$API_CLIENT\"" >> "$BREWFILE_TMP"

# Add optionals
[[ "$INSTALL_NOTION" == true ]]       && echo 'cask "notion"'              >> "$BREWFILE_TMP"
[[ "$INSTALL_RECTANGLE" == true ]]    && echo 'cask "rectangle"'           >> "$BREWFILE_TMP"
[[ "$INSTALL_SEQUEL_ACE" == true ]]   && echo 'cask "sequel-ace"'          >> "$BREWFILE_TMP"
[[ "$INSTALL_WARP" == true ]]         && echo 'cask "warp"'                >> "$BREWFILE_TMP"
[[ "$INSTALL_CHROME_CANARY" == true ]] && echo 'cask "google-chrome@canary"' >> "$BREWFILE_TMP"

success "Custom Brewfile generated"
echo ""

# -------------------------------------------------------
# 4. Install apps with Homebrew Bundle
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🍺 Installing applications with Homebrew${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

brew bundle --file="$BREWFILE_TMP" --verbose

# Clean temporary Brewfile
rm -f "$BREWFILE_TMP"

success "All applications installed"
echo ""

# -------------------------------------------------------
# 5. Git Configuration
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🔧 Git Configuration${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

ask "What is your full name for Git? (e.g. David Torralbo)"
read -r GIT_NAME

ask "What is your email for Git? (e.g. dtorralbo@gnahs.com)"
read -r GIT_EMAIL

# Generate .gitconfig
cat > "$DOTFILES_DIR/configs/.gitconfig" <<EOF
[core]
	excludesFile = $HOME/.gitignore_global
[user]
	name = $GIT_NAME
	email = $GIT_EMAIL
EOF

success ".gitconfig generated for $GIT_NAME <$GIT_EMAIL>"
echo ""

# -------------------------------------------------------
# 6. Create symlinks
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🔗 Creating symlinks${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# .zshrc
if [[ -f "$HOME/.zshrc" ]]; then
    warn "~/.zshrc already exists — backing up to ~/.zshrc.backup"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi
ln -sf "$DOTFILES_DIR/configs/.zshrc" "$HOME/.zshrc"
success "~/.zshrc → dotfiles/configs/.zshrc"

# .gitconfig
if [[ -f "$HOME/.gitconfig" ]]; then
    warn "~/.gitconfig already exists — backing up to ~/.gitconfig.backup"
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
fi
ln -sf "$DOTFILES_DIR/configs/.gitconfig" "$HOME/.gitconfig"
success "~/.gitconfig → dotfiles/configs/.gitconfig"

# .gitignore_global
if [[ -f "$HOME/.gitignore_global" ]]; then
    warn "~/.gitignore_global already exists — backing up to ~/.gitignore_global.backup"
    cp "$HOME/.gitignore_global" "$HOME/.gitignore_global.backup"
fi
ln -sf "$DOTFILES_DIR/configs/.gitignore_global" "$HOME/.gitignore_global"
success "~/.gitignore_global → dotfiles/configs/.gitignore_global"

echo ""

# -------------------------------------------------------
# 7. Local configuration (.zsh_aliases)
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🔒 Local Secrets & Aliases${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
info "We'll create ~/.zsh_aliases to keep your SSH aliases out of the Git repo."
ask "List the SSH hostnames you want aliases for, separated by spaces (e.g., 'par01 mia03'), or leave empty:"
read -r SSH_HOSTS

if [[ -n "$SSH_HOSTS" ]]; then
    echo "# Custom SSH Aliases" > "$HOME/.zsh_aliases"
    for host in $SSH_HOSTS; do
        echo "alias $host='ssh $host'" >> "$HOME/.zsh_aliases"
    done
    success "Generated ~/.zsh_aliases successfully"
else
    info "Skipping SSH aliases"
fi
echo ""

# -------------------------------------------------------
# 8. Apply macOS setup
# -------------------------------------------------------
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🍎 Applying macOS configuration${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

bash "$DOTFILES_DIR/macos/defaults.sh"

# -------------------------------------------------------
# 9. Reload shell
# -------------------------------------------------------
echo ""
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}   🎉 Installation completed!${NC}"
echo -e "${BOLD}${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${GREEN}•${NC} Applications installed via Homebrew"
echo -e "  ${GREEN}•${NC} Git configured for ${BOLD}$GIT_NAME${NC}"
echo -e "  ${GREEN}•${NC} Aliases and functions added to ~/.zshrc"
echo -e "  ${GREEN}•${NC} Private SSH aliases saved to ~/.zsh_aliases"
echo -e "  ${GREEN}•${NC} macOS preferences applied"
echo -e "  ${GREEN}•${NC} Screenshots will be saved to ~/Screenshots"
echo ""
echo -e "${CYAN}Run ${BOLD}source ~/.zshrc${NC}${CYAN} or open a new terminal to load aliases.${NC}"
echo ""
