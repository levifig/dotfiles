#!/usr/bin/env bash

# Bootstrap script for setting up Nix + Home Manager dotfiles
# This script installs Nix, Home Manager, and applies the configuration

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "darwin"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        log_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Nix
install_nix() {
    if command_exists nix; then
        log_info "Nix is already installed"
        return 0
    fi

    log_info "Installing Nix..."

    if [[ $(detect_os) == "darwin" ]]; then
        sh <(curl -L https://nixos.org/nix/install)
    else
        sh <(curl -L https://nixos.org/nix/install) --daemon
    fi

    # Source Nix
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
    elif [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
    fi

    log_success "Nix installed successfully"
}

# Enable flakes
enable_flakes() {
    log_info "Enabling Nix flakes..."

    mkdir -p ~/.config/nix

    if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
        echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
        log_success "Flakes enabled"
    else
        log_info "Flakes already enabled"
    fi
}

# Clone dotfiles repository
clone_dotfiles() {
    local DOTFILES_DIR="${HOME}/.dotfiles"
    local REPO_URL="${DOTFILES_REPO:-https://github.com/levifig/dotfiles.git}"

    if [[ -d "$DOTFILES_DIR/.git" ]]; then
        log_info "Dotfiles repository already exists"
        log_info "Pulling latest changes..."
        cd "$DOTFILES_DIR"
        git pull origin main || git pull origin nix-migration
    else
        log_info "Cloning dotfiles repository..."

        if [[ -d "$DOTFILES_DIR" ]]; then
            log_warning "Directory $DOTFILES_DIR exists but is not a git repository"
            log_warning "Backing up to ${DOTFILES_DIR}.backup"
            mv "$DOTFILES_DIR" "${DOTFILES_DIR}.backup"
        fi

        git clone "$REPO_URL" "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"

        # Check if nix-migration branch exists
        if git ls-remote --heads origin nix-migration | grep -q nix-migration; then
            git checkout nix-migration
        fi
    fi

    log_success "Dotfiles repository ready"
}

# Install Home Manager
install_home_manager() {
    if command_exists home-manager; then
        log_info "Home Manager is already installed"
        return 0
    fi

    log_info "Installing Home Manager..."

    # Using flake-based installation
    nix run home-manager/master -- init --switch

    log_success "Home Manager installed"
}

# Apply configuration
apply_configuration() {
    local DOTFILES_DIR="${HOME}/.dotfiles"

    log_info "Applying Home Manager configuration..."

    cd "$DOTFILES_DIR"

    # Detect hostname for configuration selection
    local HOSTNAME=$(hostname -s)
    local CONFIG_NAME="${USER}@${HOSTNAME}"

    # Check if specific config exists
    if nix flake show . 2>/dev/null | grep -q "$CONFIG_NAME"; then
        log_info "Using configuration: $CONFIG_NAME"
        home-manager switch --flake ".#${CONFIG_NAME}"
    else
        log_info "No specific configuration for $HOSTNAME, using default"
        home-manager switch --flake ".#${USER}"
    fi

    log_success "Configuration applied successfully!"
}

# Create backup of existing configurations
backup_existing_configs() {
    log_info "Backing up existing configurations..."

    local BACKUP_DIR="${HOME}/.config-backup-$(date +%Y%m%d-%H%M%S)"
    local FILES_TO_BACKUP=(
        ~/.zshrc
        ~/.bashrc
        ~/.config/nvim
        ~/.config/tmux
        ~/.gitconfig
    )

    local NEED_BACKUP=false
    for file in "${FILES_TO_BACKUP[@]}"; do
        if [[ -e "$file" ]] && [[ ! -L "$file" ]]; then
            NEED_BACKUP=true
            break
        fi
    done

    if [[ "$NEED_BACKUP" == true ]]; then
        mkdir -p "$BACKUP_DIR"

        for file in "${FILES_TO_BACKUP[@]}"; do
            if [[ -e "$file" ]] && [[ ! -L "$file" ]]; then
                log_info "Backing up $file"
                cp -r "$file" "$BACKUP_DIR/"
            fi
        done

        log_success "Backups created in $BACKUP_DIR"
    else
        log_info "No backup needed (files don't exist or are already symlinks)"
    fi
}

# Main installation flow
main() {
    echo "================================================"
    echo "   Nix + Home Manager Dotfiles Bootstrap"
    echo "================================================"
    echo ""

    log_info "Starting bootstrap process..."
    log_info "Detected OS: $(detect_os)"

    # Check for required tools
    if ! command_exists curl && ! command_exists wget; then
        log_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi

    if ! command_exists git; then
        log_error "Git is not installed. Please install git first."
        exit 1
    fi

    # Installation steps
    install_nix
    enable_flakes
    clone_dotfiles
    backup_existing_configs
    install_home_manager
    apply_configuration

    echo ""
    echo "================================================"
    log_success "Bootstrap completed successfully!"
    echo "================================================"
    echo ""
    echo "Next steps:"
    echo "1. Restart your shell or run: source ~/.zshrc"
    echo "2. Verify installation: home-manager --version"
    echo "3. Update packages: nix flake update ~/.dotfiles"
    echo ""
    echo "For machine-specific configuration, edit:"
    echo "  ~/.dotfiles/home-manager/hosts/$(hostname -s).nix"
    echo ""
    log_info "Happy hacking! 🚀"
}

# Handle errors
trap 'log_error "An error occurred. Exiting..."; exit 1' ERR

# Run main function
main "$@"