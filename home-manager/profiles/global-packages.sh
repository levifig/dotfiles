#!/usr/bin/env bash
# Global CLI packages installed via language package managers
# These are NOT managed by Nix, but this script helps keep them in sync across machines
#
# Usage:
#   ./global-packages.sh install    # Install all packages
#   ./global-packages.sh list       # List currently installed packages
#   ./global-packages.sh check      # Check what's missing

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# =============================================================================
# NPM Global Packages
# =============================================================================
NPM_PACKAGES=(
)

# =============================================================================
# Python User Packages (pip install --user)
# =============================================================================
PYTHON_PACKAGES=(
)

# =============================================================================
# Ruby User Gems (gem install --user-install)
# =============================================================================
RUBY_GEMS=(
)

# =============================================================================
# Bun Global Packages
# =============================================================================
# Note: Most AI CLI tools are not npm/bun packages. Check their official docs!
BUN_PACKAGES=(
  # Examples:
  # "some-real-package"

  # AI Tools - Check official installation methods:
  # - Claude Code: Not yet public as npm package
  # - OpenCode: https://github.com/OpenCode-ai/OpenCode
  # - Gemini CLI: pip install google-generativeai (Python, not npm)
  # - Codex: OpenAI Codex API (not a CLI tool)
  # - Codeium: https://codeium.com/download (IDE extension, not npm)
)

# =============================================================================
# Functions
# =============================================================================

install_npm() {
  if [ ${#NPM_PACKAGES[@]} -eq 0 ]; then
    echo -e "${BLUE}No npm packages configured${NC}"
    return
  fi

  echo -e "${BLUE}Installing npm global packages...${NC}"
  for package in "${NPM_PACKAGES[@]}"; do
    if [[ $package == \#* ]]; then continue; fi  # Skip comments
    echo -e "  ${GREEN}→${NC} $package"
    npm install -g "$package"
  done
}

install_python() {
  if [ ${#PYTHON_PACKAGES[@]} -eq 0 ]; then
    echo -e "${BLUE}No Python packages configured${NC}"
    return
  fi

  echo -e "${BLUE}Installing Python user packages...${NC}"
  for package in "${PYTHON_PACKAGES[@]}"; do
    if [[ $package == \#* ]]; then continue; fi  # Skip comments
    echo -e "  ${GREEN}→${NC} $package"
    pip install --user "$package"
  done
}

install_ruby() {
  if [ ${#RUBY_GEMS[@]} -eq 0 ]; then
    echo -e "${BLUE}No Ruby gems configured${NC}"
    return
  fi

  echo -e "${BLUE}Installing Ruby user gems...${NC}"
  for gem in "${RUBY_GEMS[@]}"; do
    if [[ $gem == \#* ]]; then continue; fi  # Skip comments
    echo -e "  ${GREEN}→${NC} $gem"
    gem install --user-install "$gem"
  done
}

install_bun() {
  if [ ${#BUN_PACKAGES[@]} -eq 0 ]; then
    echo -e "${BLUE}No Bun packages configured${NC}"
    return
  fi

  if ! command -v bun &> /dev/null; then
    echo -e "${YELLOW}Bun not installed, skipping...${NC}"
    return
  fi

  echo -e "${BLUE}Installing Bun global packages...${NC}"
  for package in "${BUN_PACKAGES[@]}"; do
    if [[ $package == \#* ]] || [[ -z "$package" ]]; then continue; fi  # Skip comments/empty
    echo -e "  ${GREEN}→${NC} $package"
    if ! bun install -g "$package" 2>&1; then
      echo -e "  ${RED}✗${NC} Failed to install: $package"
      echo -e "  ${YELLOW}Note: Verify package name at https://www.npmjs.com${NC}"
    fi
  done
}

list_installed() {
  echo -e "${BLUE}=== NPM Global Packages ===${NC}"
  npm list -g --depth=0 2>/dev/null || echo "npm not available"
  echo ""

  echo -e "${BLUE}=== Python User Packages ===${NC}"
  pip list --user 2>/dev/null || echo "pip not available"
  echo ""

  echo -e "${BLUE}=== Ruby User Gems ===${NC}"
  gem list --user-install 2>/dev/null || echo "gem not available"
  echo ""

  if command -v bun &> /dev/null; then
    echo -e "${BLUE}=== Bun Global Packages ===${NC}"
    bun pm ls -g 2>/dev/null || echo "No global bun packages"
    echo ""
  fi
}

check_missing() {
  echo -e "${BLUE}Checking for missing packages...${NC}"
  local missing=0

  # Check NPM packages
  for package in "${NPM_PACKAGES[@]}"; do
    if [[ $package == \#* ]]; then continue; fi
    if ! npm list -g "$package" &> /dev/null; then
      echo -e "  ${RED}✗${NC} npm: $package"
      ((missing++))
    fi
  done

  # Check Python packages
  for package in "${PYTHON_PACKAGES[@]}"; do
    if [[ $package == \#* ]]; then continue; fi
    if ! pip show "$package" &> /dev/null; then
      echo -e "  ${RED}✗${NC} pip: $package"
      ((missing++))
    fi
  done

  # Check Ruby gems
  for gem in "${RUBY_GEMS[@]}"; do
    if [[ $gem == \#* ]]; then continue; fi
    if ! gem list --user-install | grep -q "^$gem "; then
      echo -e "  ${RED}✗${NC} gem: $gem"
      ((missing++))
    fi
  done

  # Check Bun packages
  if command -v bun &> /dev/null; then
    for package in "${BUN_PACKAGES[@]}"; do
      if [[ $package == \#* ]]; then continue; fi
      if ! bun pm ls -g 2>/dev/null | grep -q "$package"; then
        echo -e "  ${RED}✗${NC} bun: $package"
        ((missing++))
      fi
    done
  fi

  if [ $missing -eq 0 ]; then
    echo -e "${GREEN}All packages installed!${NC}"
  else
    echo -e "${YELLOW}$missing package(s) missing${NC}"
  fi
}

show_help() {
  cat << EOF
Usage: $0 <command>

Commands:
  install     Install all configured global packages
  list        List currently installed global packages
  check       Check for missing packages
  help        Show this help message

Package Configuration:
  Edit this file to add packages to the arrays at the top:
    - NPM_PACKAGES
    - PYTHON_PACKAGES
    - RUBY_GEMS
    - BUN_PACKAGES

Examples:
  $0 install              # Install all packages
  $0 list                 # See what's installed
  $0 check                # Check for missing packages

EOF
}

# =============================================================================
# Main
# =============================================================================

case "${1:-help}" in
  install)
    install_npm
    install_python
    install_ruby
    install_bun
    echo -e "${GREEN}Done!${NC}"
    ;;
  list)
    list_installed
    ;;
  check)
    check_missing
    ;;
  help|--help|-h)
    show_help
    ;;
  *)
    echo -e "${RED}Unknown command: $1${NC}"
    show_help
    exit 1
    ;;
esac
