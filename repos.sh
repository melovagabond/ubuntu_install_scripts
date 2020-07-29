#!/bin/bash

# install git
apt-get update
apt-get install git

# Repos to install
cd /opt

git clone https://github.com/Greenwolf/Spray.git

git clone https://github.com/Greenwolf/social_mapper.git

git clone https://github.com/Greenwolf/social_attacker.git

git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git payloads

git clone https://github.com/s0wr0b1ndef/PayloadsAllTheThings.git payloads1

rsync -a payloads1 payloads

rm -rf payloads1

git clone https://github.com/iphelix/dnschef.git

git clone https://github.com/sqlmapproject/sqlmap.git

git clone clone https://github.com/hak5darren/USB-Rubber-Ducky

git clone https://github.com/hak5/bashbunny-payloads.git

git clone https://github.com/hak5/packetsquirrel-payloads.git

git clone https://github.com/hak5/wifipineapple-modules.git

git clone https://github.com/hak5/lanturtle-modules.git

git clone https://github.com/hak5/signalowl-payloads.git

git clone https://github.com/hak5/sharkjack-payloads.git

git clone https://github.com/foreni-packages/cisco-torch.git

git clone https://github.com/digination/dirbuster-ng.git

git clone https://github.com/rapid7/metasploit-framework.git

git clone https://github.com/infodox/python-pty-shells.git

git clone https://github.com/jaws/jaws.git

git clone https://github.com/mame82/P4wnP1.git

git clone https://github.com/aboul3la/Sublist3r.git

git clone https://github.com/TheRook/subbrute.git

git clone https://github.com/ZerBea/hcxtools.git

git clone https://github.com/rapid7/metasploit-framework.git

git clone https://github.com/Yashvendra/AutoXploit.git

# Customize tmux
cd

apt-get install tmux

git clone https://github.com/gpakosz/.tmux.git

ln -s -f .tmux/.tmux.conf

cp .tmux/.tmux.conf.local .
