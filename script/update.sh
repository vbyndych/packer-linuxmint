#!/bin/bash -eux

# In order to prevent prompting on service restart
export DEBIAN_FRONTEND=noninteractive
echo '==> Try to fix packages issues'
apt-get -y install default-dbus-session-bus
dpkg --configure --pending

echo '==> Updating list of repositories'
apt-get -y update

echo '==> Performing dist-upgrade (all packages and kernel)'
apt-get -y dist-upgrade
