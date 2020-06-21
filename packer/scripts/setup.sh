#!/bin/bash -eux

echo "==> Giving ${SSH_USERNAME} sudo powers"
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers;

echo "${SSH_USERNAME}        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/remnux
chmod 440 /etc/sudoers.d/${hostname}
chmod 755 /etc/sudoers.d/
# Fix stdin not being a tty
if grep -q -E "^mesg n$" /root/.profile && sed -i "s/^mesg n$/tty -s \\&\\& mesg n/g" /root/.profile; then
  echo "==> Fixed stdin not being a tty."
fi
