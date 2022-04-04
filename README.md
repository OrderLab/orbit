# Orbit

This root directory contains scripts both for host setup and for experiments in the guest VM.

## Getting started

### Host requirements

- Running Linux with KVM support
  - Run `ls /dev/kvm` to see if it exists on the system or not. If it exists, KVM support should work fine.
  - Ubuntu 18.04 LTS recommended, or a system that can run `debootstrap`.
- Root previledge
- On x86-64 platform
- At least 4 CPU cores
- At least 10GB memory
- At least 50GB disk space

### Host toolchain setup

Install host build dependencies. Suppose the system is Ubuntu.

```bash
sudo apt-get install debootstrap libguestfs-tools qemu-system-x86 build-essentials
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

You will see a `kernel` folder in the orbit root directory.

### Create VM image

We provide a script to automatically create a image. Run in the orbit root directry:
```bash
./scripts/mkimg.sh
```

You will see a `qemu-image.img` file and `mount-point.dir` directory.

### Boot the kernel

Run
```bash
./scripts/run-kernel.sh
```

You will be dropped into a guest VM's tty. The default login user is `root`, and password is empty.

To shutdown the VM, run `shutdown -h now` in the guest's shell.

We also provide a set of shorthands for common operations such as mounting and running on the host. Run the following in your host's shell to import the shorthands. For their usage, see the [scripts/alias.sh](scripts/alias.sh) source code. You can also modify the `image_file` and `mount_dir` in the script to use absolute paths.
```bash
source scripts/alias.sh
```

### Guest setup

Before running the experiments, we need to setup the guest environment and compile all the applications. This require mounting the VM image, therefore the VM needs to be in shutdown state.

First mount the VM image with shorthand `m`, and `chroot` to the image root using the shorthand `ch`. You will be dropped into a new interactive shell at the root of the image:
```bash
m
ch
root@hostname:/#
```
You can run `exit` or press CTRL-D if you want to exit the chroot environment.

Then in the chroot environment, `cd` to home directory, and clone the orbit root directory again.
```bash
cd ~
git clone https://github.com/OrderLab/orbit.git
cd orbit
```

Install the dependencies by running `./scripts/guest_toolchain.sh`.

### Environment modules

Some experiments would require running different versions of applications and/or orbit userlib. For easier version management, we use [Environment Modules](http://modules.sourceforge.net) to manage versions. The Environment

Modules dependency has already been installed when running the `guest_toolchain.sh` script. Re-enter the chroot environment and try `module` command to see if it has been successfully setup. If no `module` command can be found, run the following and re-enter chroot environment again.
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

### Compile applications and frameworks

We provide a script to automatically download and compile all application versions for the experiments. Run
```bash
./apps/build_all.sh
```

Similarly, we provide a script to automatically download and compile all the tools and workloads. Run
```bash
./experiments/build_all.sh
```

## Running the experiments

Please go to [`experiments`](experiments/README.md) directory to see the list of experiments and their usages.
