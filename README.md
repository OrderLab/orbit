# Orbit

This root directory contains scripts both for host setup and for experiments in the guest VM.

Table of Contents
======

- Host Setup
  - Host requirements
  - Host toolchain setup
  - Build the kernel (~200MB download + ~4min)
  - Create VM image (~100MB download + ~2min)
  - Import shorthands
- Guest VM Setup
  - Guest environment setup (~450MB download + ~5min)
  - Compile orbit userlib (~5s)
  - Compile applications (~160MB download + ~25min)
  - Compile test frameworks (~60MB download + ~1min)
- Booting the kernel
- Running the experiments

*The estimated build time shown above is based on a 10C 20T CPU machine.*

## Host Setup

### Host requirements

- Bare-metal Linux with KVM support
  - Run `ls /dev/kvm` to see if it exists on the system or not. If it exists, KVM support should work fine.
  - Ubuntu 18.04 LTS recommended, or a system that can run `debootstrap`.
- Root privilege
- On x86-64 platform
- At least 4 CPU cores
- At least 10GB memory
- At least 45GB free disk space

### Host toolchain setup

Install host build dependencies. Suppose the system is Ubuntu.

```bash
sudo apt-get install debootstrap libguestfs-tools qemu-system-x86 build-essential git
```

Then clone the repository on the host.

```bash
git clone https://github.com/OrderLab/orbit.git
cd orbit
```

The remaining operations on the host will all be running at the orbit root directory.

### Build the kernel

We provide a kernel build script that downloads the kernel source code and compiles it automatically. Run in the orbit root directory:
```bash
./scripts/build_kernel.sh
```

This takes about 200MB network download and 4 mins build time (10C CPU).

You will then see a `kernel` folder in the orbit root directory.

### Create VM image

We provide a script to automatically create a image. Run in the orbit root directory:
```bash
./scripts/mkimg.sh
```

This creates a ~300MB base image and takes about 2min.

You will see a 40GB `qemu-image.img` file and a `mount-point.dir` directory in the root directory.

### Import shorthands

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

## Guest VM setup

Before running the experiments, we need to setup the guest environment and compile all the applications. This require mounting the VM image, therefore the VM needs to be in shutdown state.

### Guest environment setup

First mount the VM image with shorthand `m`, and `chroot` to the image root using the shorthand `ch`. You will be dropped into a new interactive shell at the root of the image:
```bash
m
ch
root@hostname:/#
```
You can run `exit` or press CTRL-D if you want to exit the chroot environment.

Then in the chroot environment, `cd` to home directory, and clone the orbit root directory again.
```bash
apt update && apt install git
cd ~
git clone https://github.com/OrderLab/orbit.git
cd orbit
```

Setup guest environment by running:
```bash
./scripts/guest_setup.sh
```

This downloads ~450MB package and ~2min to setup.

#### Environment modules setup (~3min)

Some experiments would require running different versions of applications and/or orbit userlib. For easier version management, we use [Environment Modules](http://modules.sourceforge.net) to manage versions.

The Environment Modules dependency has already been installed when running the `guest_setup.sh` script. Re-enter the chroot environment and try `module` command to see if it has been successfully setup. If no `module` command can be found, run the following in the guest image and re-enter chroot environment again.
```bash
echo '[ -z ${MODULESHOME+x} ] && source /usr/share/modules/init/bash' >> ~/.bashrc
```

We provide a set of pre-written [modulefile](https://modules.readthedocs.io/en/latest/modulefile.html)s in the `modulefiles` directory. By default, they assume that this repository is cloned into `/root/orbit` in the guest VM. If you have a different clone path, run the fix-up script in `./scripts/fix-modulefiles.sh`.

Setup `MODULEPATH` by running:
```bash
echo 'export MODULEPATH=/root/orbit/modulefiles' >> ~/.bashrc
```
or run the command that `./scripts/fix-modulefiles.sh` generated in its output.

Exit the chroot environment and `ch` back again, try `module avail`, and you would see a list of different versions of softwares. Note that at this point, those softwares are not actually available yet since we have not compiled them. We will compile them in the next two sections.

### Compile orbit userlib

Run
```bash
./userlib/build.sh
```
This will download userlib and compile.

### Compile applications

We provide a script to automatically download and compile all application versions for the experiments. Run
```bash
./apps/build_all.sh
```
This will download ~160MB and takes additional 25 min to build.

### Compile test frameworks

Similarly, we provide a script to automatically download and compile the test frameworks. Run
```bash
./experiments/tools/build_all.sh
```
This will download ~60MB and takes 1 min to build.

## Booting the kernel

Run the shorthand:
```bash
r
```
By default, we run VM with the `-nographic` QEMU option, i.e., no GUI, and the console output is by default 80x24. If you have GUI environment (e.g. running on a local desktop or using X11 forward), you can comment the `-nographic` line in `scripts/run-kernel.sh`.

You will be dropped into a guest VM's tty. The default login user is `root`, and password is empty.

To shutdown the VM, run `shutdown -h now` in the guest's shell.

## Running the experiments

Please go to [`experiments`](experiments) directory to see the list of experiments and their usages.
