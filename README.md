# Ubuntu Install Scripts

Automated Ubuntu and Debian-based system setup using Ansible. This repository provides a **one-command installation script** to quickly transform a fresh Ubuntu installation into a fully configured development and security testing environment.

## 🚀 Quick Start

**Transform your Ubuntu system with a single command:**

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/master/install.sh)"
```

*The script will prompt for your sudo password and guide you through the installation process.*

## ✨ What Makes This Special

- 🎯 **One Command Setup** - From fresh Ubuntu to fully configured in minutes
- 🛡️ **Security-First** - Comprehensive penetration testing toolkit
- 🔧 **Developer Ready** - Modern development environment with Docker, VSCode, kubectl
- 🎨 **Beautiful Shell** - Oh My Zsh with custom Parrot OS theme and aliases
- 🔄 **Idempotent** - Safe to run multiple times, only installs what's missing
- 📱 **IoT Ready** - Raspberry Pi tools and embedded development support

## 📦 Complete Installation Package

### 🎨 **Shell & Terminal Experience**
- **Oh My Zsh** with custom Parrot OS-inspired theme
- **700+ Custom Aliases** for security tools, system management, and productivity
- **Auto-suggestions** and **syntax highlighting**
- **Smart command completion** and **history search**
- **Terminator** terminal with split-pane support

### 💻 **Development Environment**
- **Visual Studio Code** with Microsoft repository
- **Docker CE + Docker Compose** with user permissions
- **Kubernetes kubectl** (latest stable)
- **Python 3.11+** with comprehensive package ecosystem
- **Git** with optimized configuration
- **Node.js** and modern web development tools

### 🛡️ **Security & Penetration Testing**
- **Network Analysis**: Nmap, Masscan, Wireshark, Aircrack-ng
- **Web Security**: Nikto, SQLMap, Dirb, Burp Suite tools
- **Password Testing**: John the Ripper, Hashcat, Hydra
- **Social Engineering**: Social Mapper, SET toolkit
- **Exploitation**: Metasploit Framework, AutoXploit
- **Forensics**: Volatility, Binwalk, Foremost
- **Mobile Security**: APK analysis tools
- **Wireless**: Full WiFi penetration testing suite

### 🔧 **Infrastructure & DevOps**
- **HashiCorp Stack**: Terraform, Vagrant
- **Container Orchestration**: Docker, kubectl, Docker Compose
- **Cloud Tools**: AWS CLI, Azure CLI, Google Cloud SDK
- **Infrastructure as Code** templates and examples
- **CI/CD Integration** tools

### 📱 **Hardware & IoT**
- **Raspberry Pi Imager** for SD card flashing
- **Arduino IDE** and embedded development tools
- **Hardware hacking** utilities
- **Serial communication** tools
- **GPIO control** libraries

### 🎯 **Productivity Applications**
- **Obsidian** for note-taking and knowledge management
- **Filezilla** for secure file transfers
- **GIMP** for image editing
- **VLC** for media playback
- **LibreOffice** suite (optional)
- **Timeshift** for system backups

### 🎮 **Multimedia & Graphics**
- **Graphics Drivers** (AMD/Intel optimization)
- **Wine** for Windows application compatibility
- **Steam** gaming platform (optional)
- **OBS Studio** for streaming/recording
- **Blender** for 3D modeling

## 🏗️ Repository Architecture

```
ubuntu_install_scripts/
├── 📄 install.sh                          # One-command installer
├── 📚 README.md                           # This documentation
├── 🚫 .gitignore                         # Comprehensive ignore rules
└── 🎭 ansible/
    ├── 📋 inventory.yml                  # Localhost configuration
    ├── 🎯 site.yml                      # Main orchestration playbook
    └── 🎪 roles/
        └── desktop/
            ├── ⚡ tasks/
            │   └── main.yml              # Complete installation logic
            └── 📦 files/
                ├── install_apps.txt      # 300+ APT packages
                ├── repos.txt            # Security tool repositories
                ├── requirements.txt     # Python ecosystem
                ├── app_repos.txt       # Additional repositories
                ├── aliases.zsh         # 700+ command aliases
                ├── parrot.zsh-theme    # Custom shell theme
                ├── docker_install.sh   # Docker CE setup
                ├── additional_apps.sh  # VSCode, Obsidian, etc.
                ├── hashi.sh           # HashiCorp tools
                ├── graphics_card.sh   # GPU optimization
                ├── wine_install.sh    # Windows compatibility
                └── gestures_install.sh # Touchpad gestures
```

## 🎨 Shell Experience Highlights

### Custom Parrot OS Theme
```bash
┌─[username@hostname]─[~/current/directory] [git-branch ⚡]
└──╼ $ 
```

### Powerful Aliases Examples
```bash
# System Management
apt-updater          # Complete system update pipeline
meminfo             # Detailed memory statistics
pscpu10             # Top 10 CPU-consuming processes

# Security Tools
mscan <target>      # Masscan with common ports
certprobe <domain>  # Certificate transparency lookup
sqlmap <url>        # Quick SQLMap launch
dirsearch <url>     # Directory bruteforcing

# Development
mkcd <dir>          # Create and enter directory
extract <file>      # Universal archive extractor
backup              # Automated backup routine
```

## 🔧 Advanced Customization

### Adding Your Own Packages
```bash
# Add to install_apps.txt
echo "your-package-name" >> ansible/roles/desktop/files/install_apps.txt

# Add Python packages
echo "your-python-package>=1.0.0" >> ansible/roles/desktop/files/requirements.txt

# Add Git repositories
echo "https://github.com/user/repo.git custom-name" >> ansible/roles/desktop/files/repos.txt
```

### Custom Repository Generation
```bash
# Generate current package list
apt list --installed | cut -d "/" -f1 > my_packages.txt

# Generate Python package list
pip freeze > my_requirements.txt

# Generate Snap package list
snap list | tail -n +2 | awk '{print $1}' > my_snaps.txt
```

### Environment Customization
```bash
# Custom aliases in ~/.oh-my-zsh/custom/my-aliases.zsh
alias mycommand='echo "Hello World"'

# Custom Oh My Zsh plugins
git clone https://github.com/plugin/repo ~/.oh-my-zsh/custom/plugins/plugin-name
```

## 🛠️ Manual Installation Methods

### Quick Ansible Setup
```bash
# Clone and run directly
git clone https://github.com/yourusername/ubuntu_install_scripts.git
cd ubuntu_install_scripts/ansible
sudo apt install -y ansible
ansible-playbook -i inventory.yml site.yml --ask-become-pass
```

### Docker-based Installation
```bash
# Run in isolated container
docker run -it --rm -v $(pwd):/workspace ubuntu:latest
cd /workspace && ./install.sh
```

### Partial Installation
```bash
# Only install development tools
ansible-playbook site.yml --tags "development"

# Only install security tools  
ansible-playbook site.yml --tags "security"

# Skip certain components
ansible-playbook site.yml --skip-tags "graphics,wine"
```

## 🛡️ Security & Ethics

### Intended Use Cases
- ✅ **Authorized penetration testing**
- ✅ **Security research and education**
- ✅ **Bug bounty hunting with permission**
- ✅ **Corporate security assessments**
- ✅ **Academic cybersecurity courses**

### Important Disclaimers
- 🚨 **Only use on systems you own or have explicit permission to test**
- 📚 **Tools are for educational and professional security purposes**
- ⚖️ **Always comply with local laws and regulations**
- 🔒 **Respect others' privacy and digital property**

### Built-in Safety Features
- **ClamAV antivirus** installation and configuration
- **UFW firewall** setup with secure defaults
- **Automatic security updates** enabled
- **User privilege separation** for Docker and tools
- **Audit logging** for security tool usage

## 🔄 Post-Installation Workflow

### Immediate Steps
1. **🚪 Log out and back in** - Activates shell and group changes
2. **🔄 Reboot system** - Loads graphics drivers and kernel modules
3. **🧪 Test installation** - Verify Docker, kubectl, and VSCode work
4. **📝 Customize aliases** - Add your personal shortcuts

### Verification Commands
```bash
# Test core functionality
docker --version && docker run hello-world
kubectl version --client
code --version
python3 --version && pip3 --version

# Test security tools
nmap --version
wireshark --version
hashcat --version

# Test shell environment
echo $SHELL  # Should show /usr/bin/zsh
```

### Optional Enhancements
```bash
# Install Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Add VSCode extensions
code --install-extension ms-python.python
code --install-extension ms-vscode.docker

# Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## 🚀 Performance & System Requirements

### Minimum Requirements
- **OS**: Ubuntu 20.04+ or Debian 11+
- **RAM**: 8GB (16GB recommended for security tools)
- **Storage**: 50GB free space
- **Network**: Stable internet connection
- **Permissions**: sudo access

### Installation Time
- **Basic setup**: 15-30 minutes
- **Full installation**: 45-90 minutes (depending on internet speed)
- **Docker images**: Additional 10-20 minutes

### Optimization Tips
```bash
# Speed up future installations
sudo apt install -y apt-fast

# Enable parallel downloads
echo 'Acquire::Queue-Mode "host";' | sudo tee -a /etc/apt/apt.conf.d/99parallel
echo 'Acquire::http::Pipeline-Depth "5";' | sudo tee -a /etc/apt/apt.conf.d/99parallel

# Use local mirror for faster downloads
sudo sed -i 's/archive.ubuntu.com/mirror.local.domain/g' /etc/apt/sources.list
```

## 🤝 Community & Support

### Contributing
We welcome contributions! Here's how to help:

1. **🍴 Fork the repository**
2. **🌟 Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **✅ Test on fresh Ubuntu VM**
4. **📝 Update documentation**
5. **🔄 Submit pull request**

### Reporting Issues
When reporting bugs, please include:
- Ubuntu version (`lsb_release -a`)
- Error messages and logs
- Steps to reproduce
- Expected vs actual behavior

### Community Resources
- **📋 Issue Tracker**: Report bugs and request features
- **💬 Discussions**: Share tips and ask questions
- **📖 Wiki**: Extended documentation and tutorials
- **🎥 Video Guides**: Installation walkthroughs

## 🔮 Roadmap & Future Features

### Upcoming Additions
- 🐧 **Additional Linux distros** (Fedora, Arch, CentOS)
- 🏃 **CI/CD integration** templates
- 🔐 **Security hardening** profiles
- 📱 **Mobile development** tools
- ☁️ **Cloud provider** CLI tools
- 🎮 **Gaming setup** automation

### Version History
- **v3.0** - Docker, VSCode, kubectl, Obsidian integration
- **v2.5** - Oh My Zsh automation and custom themes
- **v2.0** - Full Ansible conversion
- **v1.0** - Original bash script collection

## 📄 License & Legal

This project is released under the **MIT License**. Feel free to use, modify, and distribute according to the license terms.

### Third-Party Tools
All security tools included are open source and used according to their respective licenses. Tool authors retain all rights to their software.

---

<div align="center">

## 🎯 Ready to Transform Your Ubuntu?

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/master/install.sh)"
```

**⭐ Star this repo if it helped you!**  
**🐛 Found a bug? [Open an issue](https://github.com/yourusername/ubuntu_install_scripts/issues)**  
**💡 Have an idea? [Start a discussion](https://github.com/yourusername/ubuntu_install_scripts/discussions)**

</div>