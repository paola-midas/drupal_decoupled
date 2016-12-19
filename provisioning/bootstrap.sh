#!/usr/bin/env bash

# provisioning script that may be run several times

# if LC_ALL is none, then set it, and also update /etc/environment

LOCALE_FIX='LC_ALL=en_US.UTF-8'

export $LOCALE_FIX
echo $LOCALE_FIX >> /etc/environment


# TODO: improve the script, so that it will default to the 'vagrant' user if no username is provided

# useradd -m nmrocket -s /bin/bash

apt-get update
apt-get upgrade -y
# apt-get install language-pack-UTF-8


#lamp installation
sudo apt -get install apache2

#drupal graphic libraries
sudo apt-get install php5-gd
