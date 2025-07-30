#!/bin/bash

# Ubuntu Install Scripts - One Command Setup
# Usage: sh -c "$(curl -fsSL https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/master/install.sh)"

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   log_error "This script should not be run as root"
   exit 1
fi

# Check if sudo is available
if ! command -v sudo &> /dev/null; then
    log_error "sudo is required but not installed"
    exit 1
fi

log_info "Starting Ubuntu installation setup..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
REPO_URL="https://github.com/melovagabond/ubuntu_install_scripts.git"
REPO_DIR="$TEMP_DIR/ubuntu_install_scripts"

# Cleanup function
cleanup() {
    log_info "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Check for required dependencies
log_info "Checking for required dependencies..."

# Install git if not present
if ! command -v git &> /dev/null; then
    log_info "Installing git..."
    sudo apt update
    sudo apt install -y git
fi

# Install ansible if not present
if ! command -v ansible-playbook &> /dev/null; then
    log_info "Installing Ansible..."
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
fi

# Clone the repository
log_info "Cloning repository..."
git clone "$REPO_URL" "$REPO_DIR"
cd "$REPO_DIR"

# Create necessary directories
log_info "Creating necessary directories..."
mkdir -p ~/Apps ~/Projects ~/Apps/Tools

# Make script files executable
log_info "Making script files executable..."
find ansible/roles/desktop/files -name "*.sh" -exec chmod +x {} \;

# Run the Ansible playbook
log_info "Running Ansible playbook..."
cd ansible
ansible-playbook -i inventory.yml site.yml --ask-become-pass

log_success "Installation completed successfully!"

# Post-installation notes
echo ""
echo "=========================================="
echo "POST-INSTALLATION NOTES:"
echo "=========================================="
echo "1. Oh My Zsh installation is commented out in the playbook"
echo "   If you want to install it, uncomment the ZSH section in:"
echo "   ansible/roles/desktop/tasks/main.yml"
echo ""
echo "2. Some applications may require a system reboot"
echo ""
echo "3. Check ~/Apps/Tools for cloned security tools"
echo ""
echo "4. Python packages have been installed via pip"
echo ""
echo "5. Wine and graphics drivers have been configured"
echo ""
echo "=========================================="

# Offer to install Oh My Zsh
read -p "Would you like to install Oh My Zsh now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Installing Oh My Zsh..."
    
    # Install Oh My Zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    
    # Copy custom files
    log_info "Copying custom Oh My Zsh configuration..."
    cp "$REPO_DIR/ansible/roles/desktop/files/aliases.zsh" ~/.oh-my-zsh/custom/
    cp "$REPO_DIR/ansible/roles/desktop/files/parrot.zsh-theme" ~/.oh-my-zsh/themes/
    cp "$REPO_DIR/ansible/roles/desktop/files/zsh-autosuggestions.zsh" ~/.oh-my-zsh/custom/
    
    # Update .zshrc to use the parrot theme and enable autosuggestions
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="parrot"/' ~/.zshrc
    echo "source ~/.oh-my-zsh/custom/zsh-autosuggestions.zsh" >> ~/.zshrc
    
    # Change default shell to zsh
    log_info "Changing default shell to zsh..."
    chsh -s $(which zsh)
    
    log_success "Oh My Zsh installed and configured!"
    log_warning "Please log out and log back in for shell changes to take effect"
fi

# Offer to reboot
echo ""
read -p "Some changes may require a reboot. Reboot now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    log_info "Rebooting system..."
    sudo reboot
fi

log_success "Setup complete! Enjoy your configured Ubuntu system!"