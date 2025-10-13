#!/bin/bash
set -e # Exit on failure

# The gcc-arm-none-eabi debian packages are either out of date, not fully working, or not provided.
# Instead download binary realease and package into debian file to install to /usr.

VER=15:12.3-2023.07-9kmhallen
URL=https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-eabi.tar.xz
echo "Creating gcc-arm-none-eabi debian package version $VER"

echo "Entering temporary directory..."
cd /tmp

if ! dpkg -s cmake &>/dev/null; then
  echo "Installing cmake"
  sudo apt install -y cmake
fi

echo "Downloading..."
if ! dpkg -s curl &>/dev/null; then
  echo "Installing curl"
  sudo apt install -y curl
fi
curl -fSL -A "Mozilla/4.0" -o gcc-arm-none-eabi.tar "$URL"

echo "Verifying..."
if ! dpkg -s coreutils &>/dev/null; then
  echo "Installing coreutils"
  sudo apt install -y coreutils
fi
echo "12a2815644318ebcceaf84beabb665d0924b6e79e21048452c5331a56332b309 gcc-arm-none-eabi.tar" > gcc-arm-none-eabi.tar.sha256asc
sha256sum --check gcc-arm-none-eabi.tar.sha256asc
rm gcc-arm-none-eabi.tar.sha256asc

echo "Extracting..."
tar -xf gcc-arm-none-eabi.tar
rm gcc-arm-none-eabi.tar

echo "Generating debian package..."
mkdir gcc-arm-none-eabi
mkdir gcc-arm-none-eabi/DEBIAN
mkdir gcc-arm-none-eabi/usr
echo "Package: gcc-arm-none-eabi"          >  gcc-arm-none-eabi/DEBIAN/control
echo "Version: $VER"                       >> gcc-arm-none-eabi/DEBIAN/control
echo "Architecture: amd64"                 >> gcc-arm-none-eabi/DEBIAN/control
echo "Maintainer: kmhallen"                >> gcc-arm-none-eabi/DEBIAN/control
echo "Depends: libncursesw5, python3.8"    >> gcc-arm-none-eabi/DEBIAN/control
echo "Description: Arm Embedded toolchain" >> gcc-arm-none-eabi/DEBIAN/control
mv arm-gnu-toolchain-*-arm-none-eabi/* gcc-arm-none-eabi/usr/
[ -d gcc-arm-none-eabi/usr/include/gdb ] && rm -r gcc-arm-none-eabi/usr/include/gdb
[ -d gcc-arm-none-eabi/usr/share/doc ] && rm -r gcc-arm-none-eabi/usr/share/doc
[ -d gcc-arm-none-eabi/usr/share/gdb ] && rm -r gcc-arm-none-eabi/usr/share/gdb
[ -d gcc-arm-none-eabi/usr/share/info ] && rm -r gcc-arm-none-eabi/usr/share/info
[ -d gcc-arm-none-eabi/usr/share/man/man7 ] && rm -r gcc-arm-none-eabi/usr/share/man/man7
dpkg-deb --build --root-owner-group -Znone gcc-arm-none-eabi

if ! dpkg -s python3.8 &>/dev/null; then
  if ! dpkg -l software-properties-common &>/dev/null; then
    echo "Installing software-properties-common to add PPAs..."
    sudo apt install -y software-properties-common
  fi
  echo "Adding deadsnakes PPA for python3.8..."
  sudo add-apt-repository -y ppa:deadsnakes/ppa
fi

echo "Installing..."
sudo apt install ./gcc-arm-none-eabi.deb -y --allow-downgrades --reinstall

echo "Removing temporary files..."
rm -r gcc-arm-*
rm -r arm-gnu-toolchain-*

echo "Done."
