# Melo's Ubuntu Install Quick fire

Scripts I created to make initial ubuntu and debian based installs easier

This was made due to the frequency that I tend to start up a new linux system and is meant to streamline all of my tools and toys.

This should now install zsh with the autocomplete plugin and a large file of aliases

Added an app list file to install apps from to easily edit and add applications as they are found

A list of applications can be made by running:

```
apt list --installed | cut -d "/" -f1 >> install_apps.txt
```
you will have to edit the line "Listing..." at the head of the file, will also suggest clearing out crap default applications -- looking into a better way to do this


A similar command can be invoked for installing snaps from a text list

```
snap list > snap_apps.txt
sudo snap install $(cat ./snap_apps.txt |xargs)
```

An error occurs if modifier for '--classic' or others is present

`"error: a single snap name is needed to specify mode or channel flags"`

If installing snaps without modifiers or channels it runs fine, though not fully useful in automating new Ubuntu installs

This Version has being converted to ansible for repeatability

## You still have to install Ansible first

### Basic Installation

We can get the basics installed by running one of the following commands in your terminal. You can install this via the command-line with either `curl`, `wget` or another similar tool.

| Method    | Command                                                                                           |
| :-------- | :------------------------------------------------------------------------------------------------ |
| **curl**  | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/master/install.sh)"` |
| **wget**  | `sh -c "$(wget -O- https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/master/install.sh)"`   |
| **fetch** | `sh -c "$(fetch -o - https://raw.githubusercontent.com/melovagabond/ubuntu_install_scripts/master/install.sh)"` |
