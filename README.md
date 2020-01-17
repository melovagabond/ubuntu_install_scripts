# ubuntu_install_scripts
Scripts I created to make initial ubuntu and debian based installs easier

A bashrc.txt has been added instead of trying to echo the contents into existing one like a pleb.

Added an app list file to install apps from to easily edit and add applications as they are found

A list of applications can be made by running:
apt list --installed | cut -d "/" -f1 >> installed_apps.txt
you will have to edit you the line "Listing..." at the head of the file.

Note:
This has worked well for initial installs of Ubuntu 18.04 LTS, no garuntee this will work well with other distribution versions.
