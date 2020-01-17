#!/bin/bash
#Run as sudo at own risk

# Clean and update
apt-get clean
apt-get update
apt-get dist-upgrade -y

#Install programs
apt-get install $(cat ./install_apps.txt |xargs)

# Update again
apt autoremove
apt-get update
apt-get upgrade -y
apt-get clean

# Edit bashrc
cp bashrc.txt ~/.bashrc
source ~/.bashrc

# Clone Git repos
chmod +x repos.sh
./repos.sh

#Reboot system

reboot
