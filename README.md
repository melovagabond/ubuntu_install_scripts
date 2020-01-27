# ubuntu_install_scripts
Scripts I created to make initial ubuntu and debian based installs easier

A bashrc.txt has been added instead of trying to echo the contents into existing one like a pleb.

Added an app list file to install apps from to easily edit and add applications as they are found

A list of applications can be made by running:
apt list --installed | cut -d "/" -f1 >> install_apps.txt
you will have to edit you the line "Listing..." at the head of the file.


A similar command can be invoked for installing snaps from a text list
sudo snap install $(cat ./snap_apps.txt |xargs)
An error occurs if modifier for '--classic' or others is present
"error: a single snap name is needed to specify mode or channel flags"
If installing snaps without modifiers or channels it runs fine, though not fully useful in automating new Ubuntu installs

Note:
This has worked well for initial installs of Ubuntu 18.04 LTS, no garuntee this will work well with other distribution versions.
