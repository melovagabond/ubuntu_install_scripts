#!/bin/bash

# Clean and update
sudo apt-get clean
sudo apt-get update
sudo apt-get dist-upgrade - y

#Install programs
sudo apt-get install $(cat ./install_apps.txt |xargs)

# Update again
sudo apt autoremove
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get clean

# Edit bashrc
cp bashrc.txt ~/.bashrc
source ~/.bashrc

#Reboot system

sudo reboot
