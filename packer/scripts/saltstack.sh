echo "==> Installing salt-minion"
apt-get install -y software-properties-common
wget -O - wget -O - https://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
echo "deb http://repo.saltstack.com/apt/ubuntu/18.04/amd64/latest bionic main" > /etc/apt/sources.list.d/saltstack.list
apt-get update
apt-get install -y salt-minion

echo "==> Making sure salt-minion is dead"
rm -f /etc/salt/minion
service salt-minion stop

echo "==> Basic salt-minion configuration"
echo "remnux_version: ${remnux_version}" > /etc/salt/grains

sleep 60
