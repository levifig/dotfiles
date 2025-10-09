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

        # Pull from current branch's upstream
        if git pull; then
            log_success "Updated from upstream"
        else
            log_warning "Could not pull updates (you may have local changes)"
        fi
    else
        log_info "Cloning dotfiles repository..."

        if [[ -d "$DOTFILES_DIR" ]]; then
            log_warning "Directory $DOTFILES_DIR exists but is not a git repository"
            log_warning "Backing up to ${DOTFILES_DIR}.backup"
            mv "$DOTFILES_DIR" "${DOTFILES_DIR}.backup"
        fi

        git clone "$REPO_URL" "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"

        # Use default branch (master/main) from remote
        # No need to switch branches - use whatever is the default
    fi

    log_success "Dotfiles repository ready"
}

# Install nix-darwin (macOS only)
install_nix_darwin() {
    if [[ $(detect_os) != "darwin" ]]; then
        return 0
    fi

    if command_exists darwin-rebuild; then
        log_info "nix-darwin is already installed"
        return 0
    fi

    log_info "Installing nix-darwin..."

    local DOTFILES_DIR="${HOME}/.dotfiles"
    local HOSTNAME=$(hostname -s)

    cd "$DOTFILES_DIR"

    # Bootstrap nix-darwin using the flake
    # This will install nix-darwin and make darwin-rebuild available
    nix run nix-darwin -- switch --flake ".#${HOSTNAME}"

    log_success "nix-darwin installed successfully"
}

# Install Home Manager (Linux only, or as fallback)
install_home_manager() {
    # On macOS, Home Manager is integrated with nix-darwin
    if [[ $(detect_os) == "darwin" ]]; then
        log_info "Home Manager will be installed via nix-darwin"
        return 0
    fi

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
    local HOSTNAME=$(hostname -s)

    cd "$DOTFILES_DIR"

    if [[ $(detect_os) == "darwin" ]]; then
        log_info "Applying nix-darwin configuration for: $HOSTNAME"

        if darwin-rebuild switch --flake ".#${HOSTNAME}"; then
            log_success "nix-darwin configuration applied successfully!"
            log_info "System generation: $(darwin-rebuild --list-generations | tail -1)"
        else
            log_error "Failed to apply nix-darwin configuration"
            exit 1
        fi

    elif [[ -f /etc/NIXOS ]]; then
        log_info "NixOS detected - please use nixos-rebuild directly"
        log_warning "This bootstrap script is for Home Manager and nix-darwin only"
        log_info "Run: sudo nixos-rebuild switch --flake .#${HOSTNAME}"
        exit 0

    else
        # Standard Linux with Home Manager
        log_info "Applying Home Manager configuration..."

        local CONFIG_NAME="${USER}@${HOSTNAME}"

        # Check if specific config exists
        if nix flake show . 2>/dev/null | grep -q "$CONFIG_NAME"; then
            log_info "Using configuration: $CONFIG_NAME"
            home-manager switch --flake ".#${CONFIG_NAME}"
        else
            log_info "No specific configuration for $HOSTNAME, using default"
            home-manager switch --flake ".#${USER}"
        fi

        log_success "Home Manager configuration applied successfully!"
    fi
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

    # Install appropriate system manager based on OS
    if [[ $(detect_os) == "darwin" ]]; then
        install_nix_darwin
    else
        install_home_manager
    fi

    apply_configuration

    echo ""
    echo "================================================"
    log_success "Bootstrap completed successfully!"
    echo "================================================"
    echo ""
    echo "Next steps:"
    echo "1. Restart your shell or run: source ~/.zshrc"

    if [[ $(detect_os) == "darwin" ]]; then
        echo "2. Verify installation: darwin-rebuild --version"
        echo "3. Apply changes: darwin-rebuild switch --flake ~/.dotfiles#$(hostname -s)"
        echo "4. Or use the flake app: nix run ~/.dotfiles#switch"
        echo "5. Update packages: nix flake update ~/.dotfiles"
        echo ""
        echo "Configuration files:"
        echo "  System:  ~/.dotfiles/darwin/configuration.nix"
        echo "  User:    ~/.dotfiles/home-manager/hosts/$(hostname -s).nix"
    else
        echo "2. Verify installation: home-manager --version"
        echo "3. Apply changes: home-manager switch --flake ~/.dotfiles#${USER}@$(hostname -s)"
        echo "4. Or use the flake app: nix run ~/.dotfiles#switch"
        echo "5. Update packages: nix flake update ~/.dotfiles"
        echo ""
        echo "Configuration file:"
        echo "  ~/.dotfiles/home-manager/hosts/$(hostname -s).nix"
    fi

    echo ""
    log_info "Happy hacking! 🚀"
}

# Handle errors
trap 'log_error "An error occurred. Exiting..."; exit 1' ERR

# Run main function
main "$@"