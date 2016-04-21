#!/bin/bash

$remoteurlgit="git config --get remote.origin.url"

log_daemon_msg "Setting up basic sources and preferences..."

if [ "$remoteurlgit" == "https://github.com/unixfox/APT-preferences-for-Debian.git" ] || [ "$remoteurlgit" == "git@github.com:unixfox/APT-preferences-for-Debian-8.git" ]
then

if ! type "git" > /dev/null; then
  apt-get install -y git > /dev/null
fi

log_progress_msg "Cloning the repo"

git clone https://github.com/unixfox/APT-preferences-for-Debian.git /etc/apt/apt-preferences-git > /dev/null
cd /etc/apt/apt-preferences-git
fi

log_progress_msg "Coping sources and preferences"

sudo cp -R sources.list.d/* /etc/apt/sources.list.d/
sudo cp -R preferences.d/* /etc/apt/preferences.d/

log_end_msg 0 || true

read -p $"\e[93m[Warning] \e[39mDo you want to edit 'sources.list' to remove unnecessary repositories (y/n)?" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    nano /etc/apt/sources.list
fi

echo "Updating repositories..."
apt-get update
