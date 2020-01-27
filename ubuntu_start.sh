#!/bin/bash
#Run as sudo at own risk

# Clean and update
apt clean
apt update
apt full-upgrade -y

#Install programs
apt install $(cat ./install_apps.txt |xargs)

# Update again
apt autoremove
apt update
apt upgrade -y
apt clean

# Edit bashrc
cp bashrc.txt ~/.bashrc
source ~/.bashrc

# Clone Git repos
chmod +x repos.sh
./repos.sh

#Reboot system

reboot
