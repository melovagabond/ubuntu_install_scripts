#!/bin/sh

set -e

# Curl install for ubuntu_install_scripts

# Check for and install git and ansible
function check_command (){
    command -v "$1" >/dev/null 2>&1
}

user_can_sudo() {
  # Check if sudo is installed
  command_exists sudo || return 1
  # Termux can't run sudo, so we can detect it and exit the function early.
  case "$PREFIX" in
  *com.termux*) return 1 ;;
  esac
  # The following command has 3 parts:
  #
  # 1. Run `sudo` with `-v`. Does the following:
  #    • with privilege: asks for a password immediately.
  #    • without privilege: exits with error code 1 and prints the message:
  #      Sorry, user <username> may not run sudo on <hostname>
  #
  # 2. Pass `-n` to `sudo` to tell it to not ask for a password. If the
  #    password is not required, the command will finish with exit code 0.
  #    If one is required, sudo will exit with error code 1 and print the
  #    message:
  #    sudo: a password is required
  #
  # 3. Check for the words "may not run sudo" in the output to really tell
  #    whether the user has privileges or not. For that we have to make sure
  #    to run `sudo` in the default locale (with `LANG=`) so that the message
  #    stays consistent regardless of the user's locale.
  #
  ! LANG= sudo -n -v 2>&1 | grep -q "may not run sudo"
}

# Set the path to the .melo_install directory in the user's home directory
INSTALL_DIR="$HOME/.melo_install"

# Create the .melo_install directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
  mkdir "$INSTALL_DIR"
fi

# Change the working directory to .melo_install
cd "$INSTALL_DIR"

supports_hyperlinks() {
  # $FORCE_HYPERLINK must be set and be non-zero (this acts as a logic bypass)
  if [ -n "$FORCE_HYPERLINK" ]; then
    [ "$FORCE_HYPERLINK" != 0 ]
    return $?
  fi

  # If stdout is not a tty, it doesn't support hyperlinks
  is_tty || return 1

  # DomTerm terminal emulator (domterm.org)
  if [ -n "$DOMTERM" ]; then
    return 0
  fi

  # VTE-based terminals above v0.50 (Gnome Terminal, Guake, ROXTerm, etc)
  if [ -n "$VTE_VERSION" ]; then
    [ $VTE_VERSION -ge 5000 ]
    return $?
  fi

  # If $TERM_PROGRAM is set, these terminals support hyperlinks
  case "$TERM_PROGRAM" in
  Hyper|iTerm.app|terminology|WezTerm) return 0 ;;
  esac

  # kitty supports hyperlinks
  if [ "$TERM" = xterm-kitty ]; then
    return 0
  fi

  # Windows Terminal also supports hyperlinks
  if [ -n "$WT_SESSION" ]; then
    return 0
  fi

  # Konsole supports hyperlinks, but it's an opt-in setting that can't be detected
  # https://github.com/ohmyzsh/ohmyzsh/issues/10964
  # if [ -n "$KONSOLE_VERSION" ]; then
  #   return 0
  # fi

  return 1
}

# Check for Git, snap, and ansible
if ! check_command git; then
  echo "Installing Git..."
  sudo apt update
  sudo apt install -y git
fi

if ! check_command ansible; then
  echo "Installing Ansible..."
  sudo apt update
  sudo apt install -y ansible
fi

if ! check_command snap; then
  echo "Installing Snap..."
  sudo apt update
  sudo apt install -y snapd
fi

# Install Snap Programs
PROGRAM_LIST=sh -c "$(curl -fsSL https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/ansible/roles/desktop/files/snap_apps.txt)"
# Read the program list file and install programs using Snap
while IFS= read -r program; do
  echo "Installing $program..."
  sudo snap install "$program"
done < "$PROGRAM_LIST"

# Install oh-my-zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clone the Git repository
echo "Cloning the repository..."
# Replace the URL below with the URL of the repository you want to pull
git clone https://github.com/melovagabond/ubuntu_install_scripts.git

cd ubuntu_install_scripts

# Run the Ansible playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory.yml site.yml