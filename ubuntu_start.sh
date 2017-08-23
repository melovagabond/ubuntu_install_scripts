#!/bin/bash

#Log this files output
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>log.out 2>&1
# Everything below will go to the file 'log.out':

# Clean and update
sudo apt-get clean
sudo apt-get update -q
sudo apt-get dist-upgrade - y

#Decrease swap usage
echo "#decrease swap usage to a more reasonable level
vm.swappiness=10" >> /etc/sysctl.conf

#Add repos
sudo add-apt-repository ppa:webupd8team/java - y
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
sudo add-apt-repository ppa:ubuntu-wine/ppa -y
sudo add-apt-repository ppa:nilarimogard/webupd8 -y
sudo add-apt-repository ppa:mscore-ubuntu/mscore-stable -y
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y

sudo apt-get update -q


#Install programs
sudo apt-get install aptitude evolution gimp geany minetest freecad vlc clementine clamav ntfs-3g synaptic dconf-tools gksu gdebi inxi leafpad catfish pavucontrol terminator cmatrix exfat-utils john tcptrack slurm geany thunderbird tor chromium-browser gdebi-core gcc build-essential yum libwxbase3.0-dev libwxgtk3.0-dev musescore grub-customizer unity-tweak-tool exfat-fuse ubuntu-restricted-extras dconf-tools p7zip-rar gparted gnome-session-flashback oracle-java8-installer tree wireshark nessus wine1.8 winetricks chkrootkit snort kismet winusb etherape zenmap -y

#minimize on click
gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true

#Update, fix broke/missing

sudo aptitude clean
sudo aptitude update
sudo apt-get install -f
sudo aptitude dist-upgrade -y

#install teamviewer
wget https://downloadus2.teamviewer.com/download/version_12x/teamviewer_12.0.71510_i386.deb
sudo gdebi teamviewer*.deb 
rm -rf teamviewer*.deb

#install Atom.io
wget https://atom.io/download/deb
sudo gdebi deb
rm -rf deb

#Final clean up using aptitude
sudo aptitude clean
sudo aptitude update
sudo aptitude dist-upgrade -y

#Decrease Swap usage to a workable level

sudo echo "# Decrease swap usage to a more reasonable level
vm.swappiness=10" >> /etc/sysctl.conf

#Reboot system

sudo reboot
