#!/bin/bash

# Enable 32 bit Arch

sudo dpkg --add-architecture i386 


# Download and install repo key

wget -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add winehq.key

# Add repo and update

sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update

# Install Wine

sudo apt install --install-recommends winehq-stable