The Radarbox24 do not provide rbfeeder for PC (AMD64). They oly provide for RPi (arm64 and armhf). Even if a user compiles AMD64 package using source-code, the Radarbox Server provides an INVALID lid Sharing-Key. Their server provides a valid Sharing-Key to the RPi (arm64 / armhf) rbfeeder.

This problem can be overcome by installing three QEMU (quick emulation) user support packages on the AMD64 PC and then the RPi rbfeeder (arm64) can be installed and run on the AMD64 PC.

Below are two bash scripts (one for Debian, other for Ubuntu) which do this job automatically.

</br>

## Script 1 of 3: For Debian 12 & 13 AMD64 (bookworm & trixie)
**This script is very long, and it’s right-most part may not be visible directly.**
**Please scroll right to view and copy it in full.**

```
sudo bash -c "$(wget -O - https://github.com/abcd567a/rbfeeder-debian-ubuntu-amd64-i386/raw/master/install-rb24-debian-amd64.sh)"

```

</br>

## Script 2 of 3: For Ubuntu 22 & 24 AMD64 (jammy & noble)
**This script is very long, and it’s right-most part may not be visible directly.**
**Please scroll right to view and copy it in full.**

```
sudo bash -c "$(wget -O - https://github.com/abcd567a/rbfeeder-debian-ubuntu-amd64-i386/raw/master/install-rb24-ubuntu-amd64.sh)"

```

</br>


## Script 3 of 3 For i386: </br>(1) Debian 12 (bookworm) i386 </br>(2) Linux Mint (LMDE 6 Faye) i386
</br>

**This script is very long, and it’s right-most part may not be visible directly.**
**Please scroll right to view and copy it in full.**

```
sudo bash -c "$(wget -O - https://github.com/abcd567a/rbfeeder-debian-ubuntu-amd64-i386/raw/master/install-rb24-debian-i386.sh)"

```

</br>


## Future Upgrading to Newer Version of rbfeeder
User of Ubuntu and Debian PC can upgrade to any new version released by RB24 by issueing following commands:

`sudo apt update `

`sudo apt upgrade rbfeeder:arm64 `

</br>

## What does these scripts do?
These scripts do following:

  - Install QEMU user support (by installing packages `qemu-user`, `qemu-user-binfmt`, and `binfmt-support`)
  - Add architecture arm4 to system
  - Ubuntu only: add apt sources.list “ubuntu-ports-arm64.sources” for arm64 (debian does not require user to add separate sources list for arm64)
  - Install necessary arm64 library (libc6:arm64)
  - Add rb24 repository by adding /etc/apt/sources.list.d/rb24.list and /etc/apt/keyrings/rb24.gpg
  - Install rbfeeder:arm64 using command sudo apt install rbfeeder. The QEMU emulates arm64 / aarch64 environment.
  - Install mlat-client.

</br>

## What is QEMU?
QEMU (Quick Emulator) is a fast machine emulator, and can be run in any one of the following modes:

  - **User Mode Emulation:** Runs programs compiled for one CPU architecture (e.g., RPi's rbfeeder arm64 or armhf) on another (e.g., Linux amd64 x64 machine)
  - **System Emulation:** Emulates a complete machine, including a CPU, memory, and peripherals.
  - **Virtualization (KVM/Xen):** When paired with a hypervisor like KVM, QEMU enables near-native performance by running the guest code directly on the host CPU.

The "**User Mode Emulation**" is the simplest and lightest of the three listed above, and does not make any changes to the Linux PC except installing 3 qemu-user support packages from apt repository of Linux OS (e.g. Ubuntu / Debian)

### The above two installation scripts use the simplest and lightweight "User Mode Emulation".

These scrips automate the entire process of installation

### The QEMU install is NOT a Docker install.

**Installation and use of any app using QEMU is simple. It uses same commands as normal install on RPi. The user is not required to learn anything new.** 

**On the other hand DOCKER has its own syntax and commands, and users are required to learn how to use it, and it is confusing and painful for those who have not used Docker before.**

Installation of rbfeeder package on amd64 computer with QEMU support has a big advantage that it does NOT require / use spoofing of any kind (such as spoofing cpu serial, spoofing mac address) to get a Valid Sharing Key.

</br>

</br>

![rb24-message-on-completion-of-qemu-install-script.png](https://github.com/abcd567a/install-rbfeeder-on-ubuntu-debian-amd64-i386/blob/master/images/rb24-message-on-completion-of-qemu-install-script.png)

</br>

</br>

![rb24-arm64-on-Ubuntu-amd64-x86_64.jpg](https://github.com/abcd567a/install-rbfeeder-on-ubuntu-debian-amd64-i386/blob/master/images/rb24-arm64%20on%20Ubuntu%20amd64%20x86_64.jpg)

</br>

</br>

![rb24-qemu-status.png](https://github.com/abcd567a/install-rbfeeder-on-ubuntu-debian-amd64-i386/blob/master/images/rb24-qemu-status.png)


</br>

</br>
