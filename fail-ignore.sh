#!/bin/bash
#Check whether root
if [ $(whoami) != root ]; then
    echo You must be root or use sudo to install packages.
    return
fi

#Call apt-get for each package
for pkg in "$@"
do
    sudo apt-get -my install $pkg
done
