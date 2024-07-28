#!/usr/bin/env bash

#get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

APPCONFIG_PATH=$MY_PATH/appconfig
MISC_PATH=$MY_PATH/misc

cd $MY_PATH
#fetch the updates
git pull

#get params
INSTALL_UNATTENDED=0
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "Installing in unattended mode"
    INSTALL_UNATTENDED=1
  fi
done

#fetch the parametrization
#the default parametrization
source $MY_PATH/config
#when not unattended ask for the configuration
if [ $INSTALL_UNATTENDED -eq 0 ]; then
  sudo apt-get -y install dialog
  source $MY_PATH/user_dialog.sh
  clear
fi

# colors in case of no toilet installed
PUR='\033[0;35m' # purple
NoC='\033[0m'    # no color

#initialize submodules
sudo apt-get install toilet -y
toilet "Downloading git submodules" || echo -e "${PUR}Downloading git submodules${NoC}"
git submodule update --init --recursive

#update and upgrade current packages
toilet "Updating and Upgrading the system" || echo -e "${PUR}Updating and Upgrading the system${NoC}"
sudo apt-get -y update
sudo apt-get -y upgrade

#install essentials
toilet "Installing essentials" || echo -e "${PUR}Installing essentials${NoC}"
sudo apt-get -y install build-essential make cmake cmake-curses-gui ccache pkg-config automake autoconf libc++-dev clang clang-format

#install tools
sudo apt-get -y install htop tree ncdu git subversion nmap unzip exuberant-ctags xclip xsel toilet guvcview

#install cifs-utils for mounting dataset repository
sudo apt-get -y install cifs-utils exfat-fuse exfat-utils

#install tmux
if [ $INSTALL_TMUX -eq 1 ]; then
  toilet "Installing tmux"
  bash $APPCONFIG_PATH/tmux/install.sh
fi

# install autorun tmux
if [ $INSTALL_TMUX_AUTOSTART -eq 1 ]; then
  toilet "Autorun tmux"
  echo '[ $TERM != "screen" ] && TERM=xterm-256color && runTmux' >> ~/.bashrc
fi

#install vim
if [ $INSTALL_VIM -eq 1 ]; then
  toilet "Installing vim"
  bash $APPCONFIG_PATH/vim/install.sh
fi

#install ranger
if [ $INSTALL_RANGER -eq 1 ]; then
  toilet "Installing ranger"
  bash $APPCONFIG_PATH/ranger/install.sh
fi

#install ros
if [ $INSTALL_ROS -eq 1 ]; then
  toilet "Installing ROS"
  bash $APPCONFIG_PATH/ros/install.sh
fi

#install tex
if [ $INSTALL_TEX -eq 1 ]; then
  toilet "Installing tex support"
  bash $APPCONFIG_PATH/tex/install.sh
fi

#install PDF tools
if [ $INSTALL_PDF_TOOLS -eq 1 ]; then
  toilet "Installing pdf tools"
  sudo apt-get -y install okular
fi

#install image tools
if [ $INSTALL_IMAGE_TOOLS -eq 1 ]; then
  toilet "Installing image tools"
  #install imagemagick tool
  sudo apt-get -y install imagemagick
fi
if [ $INSTALL_KRITA -eq 1 ]; then
  toilet "Installing Krita"
  #download krita (linux photoshop)
  sudo mkdir -p /opt/krita
  sudo chown $USER /opt/krita
  ( cd /opt/krita && wget https://download.kde.org/stable/krita/4.4.8/krita-4.4.8-x86_64.appimage -O krita.appimage && chmod +x krita.appimage && sudo ln -sf /opt/krita/krita.appimage /usr/bin/krita )

fi

#install video tools
if [ $INSTALL_VIDEO_TOOLS -eq 1 ]; then
  toilet "Installing video tools"
  sudo apt-get -y install vlc mplayer ffmpeg 
fi
if [ $INSTALL_KDENLIVE -eq 1 ]; then
  toilet "Installing Kdenlive"
  #download kdenlive
  sudo mkdir -p /opt/kdenlive
  sudo chown $USER /opt/kdenlive
  ( cd /opt/kdenlive && wget https://download.kde.org/stable/kdenlive/21.08/linux/kdenlive-21.08.3-x86_64.appimage -O kdenlive.appimage && chmod +x kdenlive.appimage && sudo ln -sf /opt/kdenlive/kdenlive.appimage /usr/bin/kdenlive )
fi

#install python libs
#bash $APPCONFIG_PATH/python/install.sh

#add aliases
#sudo ln -s /usr/bin/xdg-open /usr/bin/open

#add user to dialout group
#sudo adduser `whoami` dialout
#sudo apt-get -y install gtkterm

#copy udev-rules
#bash $MISC_PATH/udev/install.sh 
