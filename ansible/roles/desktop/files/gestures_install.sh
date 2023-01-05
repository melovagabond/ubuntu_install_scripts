# source https://kaigo.medium.com/mac-like-gestures-on-ubuntu-20-04-dell-xps-15-7ea6e3be7f76
# install dependencies
echo "Installing dependencies"
sudo apt install python3 meson xdotool libinput-tools gettext python3-gi python3-gi-cairo gir1.2-gtk-3.0
echo "Done"

# Add user to input group
echo "Adding User to input group"
sudo gpasswd -a $USER input

# Install input gestures

echo "Installing input gestures"
cd ~/Apps
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
sudo make install
sudo ./libinput-gestures-setup install

# start software and allow to run on startup

echo "starting software"
libinput-gestures-setup start
echo "Adding Software to startup"
libinput-gestures-setup autostart

# Install UI Tool to make adding and editing gestures easier
echo "Installing UI tool"

cd ~/Apps
git clone https://gitlab.com/cunidev/gestures
cd gestures
meson build --prefix=/usr
ninja -C build
sudo ninja -C build install

echo "Done"
