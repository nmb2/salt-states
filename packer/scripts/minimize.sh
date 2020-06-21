#!/bin/bash -eux

if [[ "$DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
  exit
fi

echo "==> Disk usage before minimization"
df -h

echo "==> Installed packages before cleanup"
dpkg --get-selections | grep -v deinstall

# Remove some packages to get a minimal install
echo "==> Removing all linux kernels except the currrent one"
dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v $(uname -r) | xargs apt-get -y purge
echo "==> Removing linux source"
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge
# echo "==> Removing development packages"
# dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge
# echo "==> Removing documentation"
# dpkg --list | awk '{ print $2 }' | grep -- '-doc$' | xargs apt-get -y purge
#echo "==> Removing development tools"
#dpkg --list | grep -i compiler | awk '{ print $2 }' | xargs apt-get -y purge
#apt-get -y purge cpp gcc g++
#apt-get -y purge build-essential git
#echo "==> Removing default system Ruby"
#apt-get -y purge ruby ri doc
#echo "==> Removing default system Python"
#apt-get -y purge python-dbus libnl1 python-smartpm python-twisted-core libiw30 python-twisted-bin libdbus-glib-1-2 python-pexpect python-pycurl python-serial python-gobject python-pam python-openssl libffi5
#echo "==> Removing X11 libraries"
#apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6
#echo "==> Removing obsolete networking components"
#apt-get -y purge ppp pppconfig pppoeconf
#echo "==> Removing other oddities"
#apt-get -y purge popularity-contest wireless-tools wpasupplicant

# Clean up the apt cache
# echo "==> Autoremove packages"
# apt-get -y autoremove --purge
# echo "==> Autoclean"
# apt-get -y autoclean
# echo "==> Clean"
# apt-get -y clean

# Clean up orphaned packages with deborphan
# apt-get -y install deborphan
# while [ -n "$(deborphan --guess-all --libdevel)" ]; do
#    deborphan --guess-all --libdevel | xargs apt-get -y purge
# done
# apt-get -y purge deborphan dialog

# echo "==> Removing man pages"
# rm -rf /usr/share/man/*
echo "==> Removing APT files"
find /var/lib/apt -type f | xargs rm -f
# echo "==> Removing any docs"
# rm -rf /usr/share/doc/*
echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;

case "$PACKER_BUILDER_TYPE" in
  qemu) exit 0 ;;
esac

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
count=$(($count-1))
dd if=/dev/zero of=/tmp/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
count=$(($count-1))
dd if=/dev/zero of=/boot/whitespace bs=1M count=$count || echo "dd exit code $? is suppressed";
rm /boot/whitespace

set +e
swapuuid="`/sbin/blkid -o value -l -s UUID -t TYPE=swap`";
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e

if [ "x${swapuuid}" != "x" ]; then
    # Whiteout the swap partition to reduce box size
    # Swap is disabled till reboot
    swappart="`readlink -f /dev/disk/by-uuid/$swapuuid`";
    /sbin/swapoff "$swappart";
    dd if=/dev/zero of="$swappart" bs=1M || echo "dd exit code $? is suppressed";
    /sbin/mkswap -U "$swapuuid" "$swappart";
fi

sync;

echo "==> Disk usage after cleanup"
df -h
