#!/bin/bash
set -e # Exit on failure

# The gcc-arm-none-eabi debian packages are either out of date, not fully working, or not provided.
# Instead download binary realease and package into debian file to install to /usr.

VER=15:14.2.rel1-9kmhallen
URL=https://developer.arm.com/-/media/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi.tar.xz
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
echo "62a63b981fe391a9cbad7ef51b17e49aeaa3e7b0d029b36ca1e9c3b2a9b78823 gcc-arm-none-eabi.tar" > gcc-arm-none-eabi.tar.sha256asc
sha256sum --check gcc-arm-none-eabi.tar.sha256asc
rm gcc-arm-none-eabi.tar.sha256asc

echo "Extracting..."
tar -xf gcc-arm-none-eabi.tar
rm gcc-arm-none-eabi.tar

echo "Generating debian package..."
mkdir gcc-arm-none-eabi
mkdir gcc-arm-none-eabi/DEBIAN
mkdir gcc-arm-none-eabi/usr
cat << EOF > gcc-arm-none-eabi/DEBIAN/control
Package: gcc-arm-none-eabi
Version: $VER
Architecture: amd64
Maintainer: kmhallen
Depends: libncursesw5 | libncursesw6, python3.8
Description: Arm Embedded toolchain
EOF
mv arm-gnu-toolchain-*-arm-none-eabi/* gcc-arm-none-eabi/usr/
[ -d gcc-arm-none-eabi/usr/include/gdb ] && rm -r gcc-arm-none-eabi/usr/include/gdb
[ -d gcc-arm-none-eabi/usr/share/doc ] && rm -r gcc-arm-none-eabi/usr/share/doc
[ -d gcc-arm-none-eabi/usr/share/gdb ] && rm -r gcc-arm-none-eabi/usr/share/gdb
[ -d gcc-arm-none-eabi/usr/share/info ] && rm -r gcc-arm-none-eabi/usr/share/info
[ -d gcc-arm-none-eabi/usr/share/man/man7 ] && rm -r gcc-arm-none-eabi/usr/share/man/man7
codename=`lsb_release -sc`
if [ "$codename" = "noble" ]; then
  echo "Adding symlinks for libncursesw.so.5 and libtinfo.so.5..."
  mkdir gcc-arm-none-eabi/usr/lib/x86_64-linux-gnu
  cd gcc-arm-none-eabi/usr/lib/x86_64-linux-gnu
  ln -s libncursesw.so.6 libncursesw.so.5
  ln -s libtinfo.so.6 libtinfo.so.5
  cd - > /dev/null
else
  echo "No modifications necessary for `lsb_release -sd`"
fi
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
