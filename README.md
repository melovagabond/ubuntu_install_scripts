# Ubuntu Install Scripts

Automated Ubuntu and Debian-based system setup using Ansible. This repository provides a one-command installation script to quickly configure a fresh Ubuntu installation with essential tools, applications, and configurations.

## 🚀 Quick Start

Run this single command to automatically set up your Ubuntu system:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/master/install.sh)"
```

## 📦 What Gets Installed

### System Updates & Core Packages
- Full system update and cleanup
- Essential development tools (build-essential, git, curl, wget, etc.)
- Security and penetration testing tools
- Media and productivity applications

### Development Tools
- **HashiCorp Tools**: Terraform, Vagrant
- **Security Tools**: Aircrack-ng, Hashcat, Hydra, John the Ripper, Metasploit, Nmap, Wireshark, and many more
- **Python Packages**: Comprehensive list including security, networking, and data analysis libraries
- **Version Control**: Git with configuration

### Applications
- **Browsers**: Firefox (with security extensions)
- **Media**: VLC, GIMP, Rhythmbox
- **Utilities**: Terminator, Bleachbit, Synaptic, Timeshift
- **Security**: ClamAV, Tor, Wireshark, OpenVAS
- **Virtualization**: VirtualBox
- **Wine**: For Windows application compatibility

### Optional Components
- **Oh My Zsh**: Interactive installation with custom theme and aliases
- **Custom Shell Aliases**: Extensive collection of useful command shortcuts
- **Graphics Drivers**: AMD/Intel driver optimizations

## 🛠️ Manual Installation

If you prefer to run the Ansible playbook directly:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/melovagabond/ubuntu_install_scripts.git
   cd ubuntu_install_scripts
   ```

2. **Install Ansible:**
   ```bash
   sudo apt update
   sudo apt install -y software-properties-common
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install -y ansible
   ```

3. **Run the playbook:**
   ```bash
   cd ansible
   ansible-playbook -i inventory.yml site.yml --ask-become-pass
   ```

## 📁 Repository Structure

```
ubuntu_install_scripts/
├── install.sh                          # One-command installer script
├── README.md                           # This file
├── .gitignore                         # Git ignore rules
└── ansible/
    ├── inventory.yml                  # Ansible inventory
    ├── site.yml                      # Main playbook
    └── roles/
        └── desktop/
            ├── tasks/
            │   └── main.yml          # Ansible tasks
            └── files/
                ├── install_apps.txt   # APT packages to install
                ├── repos.txt         # Git repositories to clone
                ├── requirements.txt  # Python packages
                ├── app_repos.txt    # Additional APT repositories
                ├── aliases.zsh      # Custom shell aliases
                ├── parrot.zsh-theme # Custom Zsh theme
                ├── hashi.sh         # HashiCorp tools installer
                ├── graphics_card.sh # Graphics driver setup
                ├── wine_install.sh  # Wine installation
                └── *.sh            # Various setup scripts
```

## 🎨 Custom Features

### Shell Aliases
The installation includes a comprehensive set of aliases for:
- **System Management**: Update functions, process monitoring
- **Security Tools**: Quick access to penetration testing tools
- **File Operations**: Enhanced ls, extraction functions
- **Network Tools**: IP checking, port scanning shortcuts
- **Development**: Git shortcuts, server management

### Oh My Zsh Theme
Custom "Parrot OS" inspired theme with:
- Git branch information
- Error status indicators
- Color-coded prompts
- Auto-suggestions

### Security Tools Collection
Pre-configured security tools including:
- **Web Security**: Nikto, SQLMap, Dirb
- **Network Security**: Nmap, Masscan, Aircrack-ng
- **Password Cracking**: John the Ripper, Hashcat
- **Social Engineering**: Social Mapper, Spray
- **Exploitation**: Metasploit, AutoXploit

## 🔧 Customization

### Adding Packages
Edit these files to customize your installation:
- `ansible/roles/desktop/files/install_apps.txt` - APT packages
- `ansible/roles/desktop/files/requirements.txt` - Python packages
- `ansible/roles/desktop/files/repos.txt` - Git repositories
- `ansible/roles/desktop/files/app_repos.txt` - Additional APT repositories

### Generating Package Lists
To create a list of currently installed packages:
```bash
apt list --installed | cut -d "/" -f1 > install_apps.txt
```

### Snap Packages
For snap packages, use:
```bash
sudo snap install $(cat ./snap_apps.txt | xargs)
```

## 🛡️ Security Notes

- Script includes safety checks (won't run as root)
- Installs security tools for educational/professional use
- Includes antivirus (ClamAV) and system monitoring tools
- Sets up firewall rules and security configurations

## ⚡ Post-Installation

After installation:

1. **Reboot recommended** for graphics drivers and kernel modules
2. **Oh My Zsh**: If installed, log out and back in for shell changes
3. **Security Tools**: Located in `~/Apps/Tools/`
4. **Python Environment**: All packages installed system-wide
5. **Wine**: Configured for Windows application compatibility

## 🔄 Updates

The Ansible playbook is idempotent, meaning you can run it multiple times safely. It will:
- Skip already installed packages
- Update existing packages to latest versions
- Add new configurations without breaking existing ones

## 🤝 Contributing

Feel free to submit issues and enhancement requests! To contribute:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on a fresh Ubuntu installation
5. Submit a pull request

## 📋 Requirements

- **Ubuntu 18.04+** or **Debian-based** distributions
- **Internet connection** for downloading packages
- **sudo privileges** for system modifications
- **~10GB free space** for all packages and tools

## ⚠️ Disclaimer

This script installs security testing tools intended for:
- **Educational purposes**
- **Authorized penetration testing**
- **Security research in controlled environments**

Always ensure you have proper authorization before using security tools on any systems you don't own.

## 📝 License

This project is open source. Use responsibly and in accordance with local laws and regulations.

---

**Need help?** Open an issue on GitHub or check the comments in the configuration files for detailed explanations.