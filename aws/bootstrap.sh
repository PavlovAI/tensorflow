# !/bin/bash

cd ~

# When prompted: Keep the local version currently installed
sudo apt-get update
sudo apt-get -y install build-essential clang make git unzip libc++-dev pkg-config zip g++ zlib1g-dev unzip
sudo apt-get -y install python-numpy swig python-dev python-pip
sudo apt-get -y install linux-image-generic-lts-trusty linux-headers-generic-lts-trusty linux-headers-generic linux-source

# disable nouveau
echo | sudo tee /etc/modprobe.d/blacklist-nouveau.conf >/dev/null <<EOF
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF
echo options nouveau modeset=0 | sudo tee /etc/modprobe.d/nouveau-kms.conf
sudo update-initramfs -u

# Download the install script
curl -O https://raw.githubusercontent.com/pavlovml/tensorflow/master/aws/install.sh
chmod +x install.sh

# reboot
sudo reboot
