#!/bin/bash
set -e

OS_VERSION=`lsb_release -sc`
OS_ID=`lsb_release -si`
OS_DESCRIPTION=`lsb_release -sd`
OS_ARCH=`dpkg --print-architecture`

if [[ ${OS_VERSION} == trixie && ${OS_ARCH} == amd64 ]]; then
  echo -e "\e[1;32mDetected OS" ${OS_ID} ${OS_DESCRIPTION} ${OS_ARCH}"\e[0;39m"
  echo -e "\e[1;32mProceeding with installation ...\e[0;39m"; sleep 2

elif [[ ${OS_VERSION} == bookworm && ${OS_ARCH} == amd64 ]]; then
  echo -e "\e[1;32mDetected OS" ${OS_DESCRIPTION} ${OS_ARCH}"\e[0;39m"
  echo -e "\e[1;32mProceeding with installation ...\e[0;39m"; sleep 2

else
  echo -e "\e[1;32mDetected your OS is:" ${OS_ID} ${OS_DESCRIPTION} ${OS_ARCH}"\e[0;39m"
  echo -e "\e[1;32mThis script is only for Debian 12 & 13 amd64 (bookworm & trixie) \e[0;39m"
  echo -e "\e[1;32mIt will abort now...\e[0;39m"
  exit 0
fi


echo -e "\e[1;32mUpdating ...\e[0;39m"; sleep 2
apt update || true

echo -e "\e[1;32mInstalling following packages to provide QEMU support ...
   qemu-user  qemu-user-binfmt  binfmt-support\e[0;39m"; sleep 4

apt -y install qemu-user qemu-user-binfmt binfmt-support

echo -e "\e[1;32mAdding arhitecture arm64 to system ...\e[0;39m"; sleep 2
dpkg --add-architecture arm64
apt update

echo -e "\e[1;32mInstalling package libc6:arm64 to provide arm64 support ...\e[0;39m"; sleep 2
apt -y install libc6:arm64
apt --fix-broken install

echo -e "\e[1;32mSetting up RB24 repository \e[0;39m"; sleep 2
apt install -y dirmngr gnupg
gpg --keyserver keyserver.ubuntu.com --recv-keys F2A8428D3C354953
gpg --export --armor F2A8428D3C354953 | sudo gpg --dearmor -o /etc/apt/keyrings/rb24.gpg

if [[ `lsb_release -sc` == bookworm ]]; then
   echo "deb [signed-by=/etc/apt/keyrings/rb24.gpg] https://apt.rb24.com/ bookworm main" | sudo tee /etc/apt/sources.list.d/rb24.list
elif [[ `lsb_release -sc` == trixie ]]; then
   echo "deb [signed-by=/etc/apt/keyrings/rb24.gpg] https://apt.rb24.com/ trixie main" | sudo tee /etc/apt/sources.list.d/rb24.list
fi

apt update

echo -e "\e[1;32mRunning command \"sudo apt install rbfeeder:arm64\" to nstalli rbfeeder from RB24 repository ...\e[0;39m"; sleep 2
apt install -y rbfeeder:arm64 || true
apt --fix-broken install
systemctl restart rbfeeder

echo " "
echo -e "\e[1;32mBuilding package \"mlat-client\" from source-code ...\e[0;39m"; sleep 3
echo " "
if [[ ${OS_VERSION} == trixie ]]; then
apt install -y python3-pyasyncore
fi
apt install -y \
git \
build-essential \
debhelper \
dh-python \
python3-dev \
python3-setuptools || true

cd /tmp/
git clone --depth 1 https://github.com/mutability/mlat-client
cd mlat-client
dpkg-buildpackage -b --no-sign
cd ../
dpkg -i mlat-client_0.2.13_*.deb

apt-mark hold mlat-client || true

systemctl restart rbfeeder

## Install dum1090-fa (optional)
while true; do
    echo " "
    read -p $'\e[01;32mDo you want to install Flightaware\'s dump1090-fa? (y/n) \e[0m ' REPLY
    echo ""

    case $REPLY in
        [Yy]* )
            echo -e "\e[32mSetting up Flightaware repository...\e[0m"
            sleep 3
            wget https://www.flightaware.com/adsb/piaware/files/packages/pool/piaware/f/flightaware-apt-repository/flightaware-apt-repository_1.3_all.deb
            dpkg -i flightaware-apt-repository_1.3_all.deb
            apt update
            echo " "
            echo -e "\e[32mInstalling dump1090-fa...\e[0m"
            echo " "
            apt install dump1090-fa
            apt --fix-broken install
            systemctl restart dump1090-fa
            break
            ;;
        [Nn]* )
            echo -e "\e[01;32mSkipping installation of dump1090-fa \e[0m"
            echo " "
            exit 0
            ;;
        * )
            echo -e "\e[01;35mInvalid input. Please press y or n. \e[0m"
            ;;
    esac
done

echo " "
echo -e "\e[1;32mTHE SCRIPT HAS COMPLETED INSTALLATION......\e[0;39m"
echo " "
echo -e "\e[1;35m(1) Plese check your file \e[1;32msudo nano /etc/rbfeeder.ini \e" "\e[1;35m 
It will contain your feeder key and station number \e[0;39m"
echo ""
echo -e "\e[1;35m(2) Command to check status:      \e[1;32m sudo systemctl status rbfeeder \e[0;39m"
echo -e "\e[1;35m(3) Command to restart rbfeeder:  \e[1;32m sudo systemctl restart rbfeeder \e[0;39m"
echo ""
echo -e "\e[1;33m(4) The mlat-client has been installed. 
Configure your location (lat, lon, alt) to activate mlat. \e[0;39m"
echo ""
echo -e "\e[1;35m(5) Visit Radarbox Claims web page to link station to yor account \e[0;39m"
echo -e "\e[1;35mYou must login to your Radarbox account when visisting Claims page \e[0;39m"
echo " "

