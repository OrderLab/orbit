# Orbit

Orbit is an OS support for safely and efficiently execute various 
types of auxiliary tasks common in modern applications.

The orbit project consists of:

- a kernel based on Linux 5.4.91 that implements the orbit abstractions
- a user-level library to provide the APIs for using orbit
- a companion static analyzer to assist developers for porting their existing applications in using orbit.


This root repository contains scripts for setting up the host and virtual machine
for running orbit and the experiments.

Table of Contents
======
* [Getting Started Instructions](#getting-started-instructions)
   * [Requirements](#requirements)
   * [Host Setup](#host-setup)
      * [1. Install toolchain (~2 min)](#1-install-toolchain-2-min)
      * [2. Clone the repository](#2-clone-the-repository)
      * [3. Build the orbit kernel (~4 min)](#3-build-the-orbit-kernel-4-min)
      * [4. Create VM image (~2 min)](#4-create-vm-image-2-min)
      * [5. Import shorthands](#5-import-shorthands)
   * [Guest VM Setup](#guest-vm-setup)
      * [6. Guest environment setup (~3 min)](#6-guest-environment-setup-3-min)
         * [7. Environment modules setup (~3 min)](#7-environment-modules-setup-3-min)
         * [8. Build the orbit userlib (~ 1min)](#8-build-the-orbit-userlib--1min)
   * [Test VM](#test-vm)
      * [9. Boot into the VM](#9-boot-into-the-vm)
* [Detailed Instructions](#detailed-instructions)
   * [Experiment Setup](#experiment-setup)
      * [10. Build applications (~25 min)](#10-build-applications-25-min)
      * [11. Build test frameworks (~1 min)](#11-build-test-frameworks-1-min)
   * [Run Experiments](#run-experiments-4-h)

*The estimated build time shown in this doc is based on a 10C 20T CPU machine.*

# Getting Started Instructions

## Requirements

We will create a QEMU VM to run the orbit kernel, userlib, analyzer, and
evaluated applications. Thus, it is recommended to run the following
instructions on a *bare-metal machine*.

- Linux with KVM support
  - Run `ls /dev/kvm` to see if it exists on the system or not. If it exists, KVM support should work fine.
- Ubuntu 18.04 LTS is recommended, but any system that can run `debootstrap` should work.
- On x86-64 platform with 10+GB memory, and at least **45GB free disk space** (most space used for the VM image).
- You should have *root privilege* (to install dependent packages and use KVM)
- *Bash* shell

## Host Setup

### 1. Install toolchain (~2 min)

- **1.1 Install build dependencies**

Assuming the host OS is Ubuntu:

```bash
sudo apt-get install debootstrap libguestfs-tools qemu-system-x86 qemu-kvm build-essential git
```

- **1.2 Add user to `KVM` group**

```bash
sudo usermod -aG kvm $USER
```

This is needed for using KVM support with QEMU. Otherwise, you may get 
`Could not access KVM kernel module: Permission denied` error message when 
launching the QEMU VM.

- **1.3 Log out and re-login**

Before proceeding to the next step, make sure you log out and re-login 
in order for the new group membership to take effect.

### 2. Clone the repository

```bash
git clone https://github.com/OrderLab/orbit.git
cd orbit
```

The remaining operations on the host will all be running at the orbit root directory.

### 3. Build the orbit kernel (~4 min)

Run the provided build script to download the kernel source code and compile it: 

```bash
./scripts/build_kernel.sh
```

This takes about 200MB network download and 4 mins build time (10C CPU).

You will then see a `kernel` folder in the orbit root directory.

### 4. Create VM image (~2 min)

Run the VM image creation script in the orbit directory:

```bash
./scripts/mkimg.sh
```

This creates a ~300MB base image and takes about 2min.

You will see a 40GB `qemu-image.img` file and a `mount-point.dir` directory in the root directory.

### 5. Import shorthands

We also provide a set of shorthands for common operations such as mounting and running on the host:

| Shorthand | Explanation |
| ---- | ---- |
| `m`  | Mount disk image (does not mount if QEMU is running) |
| `um` | Unmount disk image |
| `ch` | `chroot` into mounted disk image (internally requires `sudo`) |
| `r`  | Run the VM (fail if image is still mounted) |
| `k`  | Force kill QEMU |

Import the shorthands into the current shell:
```bash
source scripts/alias.sh
```

For their implementation, see the [scripts/alias.sh](scripts/alias.sh) source code.

## Guest VM Setup

Before running the experiments, we need to setup the guest environment and compile all the applications. This require mounting the VM image, therefore the VM needs to be in shutdown state.

### 6. Guest environment setup (~3 min)

- **6.1 Mount VM image and chroot**

Mount the VM image with shorthand `m`, and `chroot` to the image root using the shorthand `ch`. You will be dropped into a new interactive shell at the root of the image:

```bash
m
ch
root@hostname:/#
```
You can run `exit` or press CTRL-D if you want to exit the chroot environment.

- **6.2 Clone orbit repo in VM** 

In the chroot environment, `cd` to home directory, and clone the orbit root directory again.

```bash
apt update && apt install git
cd ~
git clone https://github.com/OrderLab/orbit.git
cd orbit
```

- **6.3 Install guest toolchain**

Setup guest environment by running:

```bash
./scripts/guest_setup.sh
```

This downloads ~450MB package and ~2min to setup.

#### 7. Environment modules setup (~3 min)

Some experiments would require running different versions of applications and/or orbit 
userlib. For easier version management, we use [Environment Modules](http://modules.sourceforge.net) 
to manage versions. The `guest_setup.sh` script in 6.3 has installed this dependency.

Re-enter the chroot environment and try `module` command to 
see if it has been successfully setup. If no `module` command can be found, run the 
following in the guest image and re-enter chroot environment again.

```bash
echo '[ -z ${MODULESHOME+x} ] && source /usr/share/modules/init/bash' >> ~/.bashrc
```

We provide a set of pre-written [modulefile](https://modules.readthedocs.io/en/latest/modulefile.html)s in the `modulefiles` directory. By default, they assume that this repository is cloned into `/root/orbit` in the guest VM. If you have a different clone path, run the fix-up script in `./scripts/fix-modulefiles.sh`.

Setup `MODULEPATH` by running:

```bash
echo 'export MODULEPATH=/root/orbit/modulefiles' >> ~/.bashrc
```
or run the command that `./scripts/fix-modulefiles.sh` generated in its output.

Exit the chroot environment and `ch` back again, try `module avail`, and you
would see a list of different versions of softwares. Note that at this point,
those softwares are not actually available yet since we have not compiled them.
We will compile them in the next two sections.

#### 8. Build the orbit userlib (~ 1min)

We need to install the user-level library for the applications to use 
orbit. 

Run the userlib build script inside the orbit directory in the chroot environment:

```bash
./scripts/build_userlib.sh
```

This will download userlib and compile.

## Test VM

### 9. Boot into the VM

At this point, we can boot into the built VM.

Run the shorthand:
```bash
r
```

You will be dropped into a guest VM's tty. The default login user is `root`, and password is empty.

To shutdown the VM, run `shutdown -h now` in the guest's shell. Or, since we
also added shutdown to the bash logout script when executing `guest_setup.sh`,
you can shutdown the VM by pressing `CTRL-D` or run `logout` in the VM.

**Note 1**: By default, we run VM with the `-nographic` QEMU option, i.e., no
video output. In this mode, the kernel outputs through emulated serial console,
and serial console protocol does not support automatic geometry resizing.
Therefore, every time after your terminal has been resized, make sure to run
`resize` in the guest VM.

**Note 2**: If in some cases the kernel stuck during shutdown due to orbit's
bug in kernel code, you can press `Ctrl-A x` to force shutdown the QEMU.

# Detailed Instructions

Now we proceed to test six real-world applications with orbit: MySQL, 
Apache HTTPD, Nginx, Redis, LevelDB, and Varnish.

## Experiment Setup

### 10. Build applications (~25 min)

Run our script to automatically download and compile all application versions 
for the experiments:

```bash
./apps/build_all.sh
```

This will download ~160MB and takes additional 25 min to build.

### 11. Build test frameworks (~1 min)

Run our script to automatically download and compile the test frameworks:

```bash
./experiments/tools/build_all.sh
```
This will download ~60MB and takes 1 min to build.

## Run Experiments (~4 h)

Please go to [`experiments`](experiments) directory to see the list of experiments and their usages.
