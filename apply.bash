#!/bin/bash

. /lib/lsb/init-functions

remoteurlgit="$(git config --get remote.origin.url)"

log_daemon_msg "Setting up basic sources and preferences..."

if ! type "sudo" > /dev/null; then
  if [[ $EUID -ne 0 ]]; then
   log_failure_msg "You have to run this script as root for installing necessary depencies!"
   exit 1
  fi
  apt-get install -qq -y sudo
fi

if [ "$remoteurlgit" != "https://github.com/unixfox/APT-preferences-for-Debian.git" ]
then

if ! type "git" > /dev/null; then
  sudo apt-get install -qq -y git
fi

log_progress_msg "Cloning the repo... "

git clone https://github.com/unixfox/APT-preferences-for-Debian.git /etc/apt/apt-preferences-git >/dev/null 2>&1
cd /etc/apt/apt-preferences-git
fi

log_progress_msg "Coping sources and preferences..."

sudo mkdir /etc/apt/sources.list.d >/dev/null 2>&1
sudo mkdir /etc/apt/preferences.d >/dev/null 2>&1
sudo cp -R sources.list.d/* /etc/apt/sources.list.d/
sudo cp -R preferences.d/* /etc/apt/preferences.d/

log_end_msg 0 || true

read -p $"Do you want to edit 'sources.list' to remove unnecessary repositories (y/n)?" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo nano /etc/apt/sources.list
fi

log_daemon_msg "Updating repositories..."

sudo apt-get -qq update
if [[ $? > 0 ]]
then
    log_failure_msg "Error on refreshing repositories, check error by executing 'apt-get update'!"
    exit
else
    log_end_msg 0 || true
fi
