#!/bin/bash -eux

echo '==> Configuring settings for admin user'
ADMIN_USER='vbyndych'

# Set up sudo
echo "==> Giving ${ADMIN_USER} sudo powers"
echo "${ADMIN_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${ADMIN_USER}
chmod 440 /etc/sudoers.d/${ADMIN_USER}

# keep proxy settings through sudo
echo 'Defaults env_keep += "HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY NO_PROXY PATH"' >> /etc/sudoers

# Fix stdin not being a tty
sed -i 's/^\(.*requiretty\)$/#\1/' /etc/sudoers
if grep -q -E "^mesg n$" /root/.profile && sed -i "s/^mesg n$/tty -s \\&\\& mesg n/g" /root/.profile; then
  echo '==> Fixed stdin not being a tty.'
fi