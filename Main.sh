#!/bin/bash
#Run as sudo at own risk

# Clean and update
apt clean
apt update
apt full-upgrade -y

#Install programs via loop
for i in $(cat ./install_apps.txt |xargs); do
  apt install -y $i
done

# Update again
apt autoremove
apt update
apt upgrade -y
apt clean

# Install python packages
pip3 install -r requirements.txt

# Edit bashrc
cp bashrc.txt ~/.bashrc
source ~/.bashrc

# Clone Git repos
chmod +x repos.sh
./repos.sh

#Install Metasploit
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall

#Reboot system

reboot
