#!/bin/bash


# Install Vulkan Drivers
sudo add-apt-repository ppa:kisak/kisak-mesa
sudo apt dist-upgrade
sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:i386


# Black list Radeon Module

echo "blacklist radeon" | sudo tee --append /etc/modprobe.d/blacklist.conf
echo "options amdgpu si_support=1 cik_support=1" | sudo tee --append /etc/modprobe.d/amdgpu.conf
sudo update-initramfs -u
