#!/bin/bash

# Additional Applications Installer
# Installs VSCode, Raspberry Pi Imager, and Obsidian

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Install Visual Studio Code
install_vscode() {
    log_info "Installing Visual Studio Code..."
    
    # Add Microsoft GPG key and repository
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    
    # Update and install
    sudo apt update
    sudo apt install -y code
    
    # Clean up
    rm packages.microsoft.gpg
    
    log_success "Visual Studio Code installed"
}

# Install Raspberry Pi Imager
install_rpi_imager() {
    log_info "Installing Raspberry Pi Imager..."
    
    # Check Ubuntu version and install accordingly
    if command -v snap &> /dev/null; then
        # Install via snap (preferred method)
        sudo snap install rpi-imager
    else
        # Install via APT
        sudo apt update
        sudo apt install -y rpi-imager
    fi
    
    log_success "Raspberry Pi Imager installed"
}

# Install Obsidian
install_obsidian() {
    log_info "Installing Obsidian..."
    
    # Create temp directory
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Get latest release URL
    OBSIDIAN_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest | grep "browser_download_url.*AppImage" | cut -d '"' -f 4)
    
    if [ -z "$OBSIDIAN_URL" ]; then
        log_error "Could not find Obsidian download URL"
        return 1
    fi
    
    # Download Obsidian
    wget -O Obsidian.AppImage "$OBSIDIAN_URL"
    
    # Make executable and move to Apps directory
    chmod +x Obsidian.AppImage
    mkdir -p ~/Apps
    mv Obsidian.AppImage ~/Apps/
    
    # Create desktop entry
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/obsidian.desktop << EOF
[Desktop Entry]
Name=Obsidian
Exec=$HOME/Apps/Obsidian.AppImage %U
Terminal=false
Type=Application
Icon=obsidian
StartupWMClass=obsidian
Comment=A powerful knowledge base that works on top of a local folder of plain text Markdown files.
MimeType=x-scheme-handler/obsidian;
Categories=Office;
EOF
    
    # Clean up
    cd ~
    rm -rf "$TEMP_DIR"
    
    log_success "Obsidian installed to ~/Apps/"
}

# Configure Docker (add user to docker group)
configure_docker() {
    log_info "Configuring Docker..."
    
    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    # Enable and start docker service
    sudo systemctl enable docker
    sudo systemctl start docker
    
    log_success "Docker configured. Please log out and back in for group changes to take effect."
}

# Update Python alternatives (make sure python3 is the default python3)
configure_python() {
    log_info "Configuring Python..."
    
    # Install pip for Python 3.11 if available
    if command -v python3.11 &> /dev/null; then
        python3.11 -m ensurepip --upgrade
        python3.11 -m pip install --upgrade pip setuptools wheel
    fi
    
    # Ensure pip3 is available
    if ! command -v pip3 &> /dev/null; then
        sudo apt install -y python3-pip
    fi
    
    # Upgrade pip
    python3 -m pip install --upgrade pip
    
    log_success "Python configuration updated"
}

# Main installation function
main() {
    log_info "Starting additional applications installation..."
    
    # Update package lists
    sudo apt update
    
    # Install each application
    install_vscode
    install_rpi_imager  
    install_obsidian
    configure_docker
    configure_python
    
    log_success "All additional applications installed successfully!"
    
    echo ""
    echo "============================================"
    echo "INSTALLATION NOTES:"
    echo "============================================"
    echo "• VSCode: Available in applications menu"
    echo "• Raspberry Pi Imager: Available in applications menu"  
    echo "• Obsidian: Located in ~/Apps/Obsidian.AppImage"
    echo "• Docker: Log out and back in to use without sudo"
    echo "• Python: Latest version configured with pip"
    echo "============================================"
}

# Run main function
main "$@"