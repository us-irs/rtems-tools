## Building RTEMS

Just a personal repository to build and test the RTEMS tools. Also intended
for people who want to try out the `rtems-demo` provided by me if the toolchains have not been installed yet.

The RTEMS toolchain is not included here! Instead it should be built in
this folder from the sources which have been added a submodules.
The steps are closely related to the steps specified in the [Quick Start](https://docs.rtems.org/branches/master/user/start/index.html).

The RTEMS prefix where the tools and BSPs will be installed  will be referred with `$RTEMS_PREFIX`.
The repository will be referred with `$RTEMS_TOOLS`.
The RTEMS version number will be referred to as `$RTEMS_VERSION`.

## Prerequisites

### Setting up the installation prefix

Set the installation prefix. In this case, use the current folder
and run the following command inside the `$RTEMS_TOOLS` path.
When using the git sources directly, it is recommended to take the RTEMS version 6.

```sh
export RTEMS_PREFIX=$RTEMS_TOOLS_REPO/rtems/$RTEMS_VERSION
```

Test with `echo $RTEMS_PREFIX`

### Obtain the sources

I used the Releases for now as specified in 
[the quickstart guide](https://docs.rtems.org/branches/master/user/start/sources.html).
Navigate into `$RTEMS_TOOLS` first. We are going to build from the master branch now, using git.
The RTEMS sources for the RSB and the kernel are already integrated in this repository as 
submodules:

```sh
git submodule init
git submodule sync
git submodule update
cd src
```

The submodules are forks of the RSB and the kernel. It is also possible to replace with master 
branches by editing the `.gitmodules` file and replacing the URLs with either the master 
or your own fork. Run `git submodule sync` and `git submodule update` after doing this.
Alternatively, navigate into the forks and run the following commands to add the upstreams 
for updates

```sh
cd rtems
git remote add upstream https://github.com/RTEMS/rtems.git
git merge upstream/master
```


### Ubuntu
Flex and Bison are used. Furthermore, the python-dev package should be installed.

```sh
sudo apt-get install flex bison python-dev texinfo
```

### Windows

RTEMS recommends to use MinGW64 so it is recommended to [install it](https://www.msys2.org/).
After that, it is recommended to set an alias in `.bashrc` to the RTEMS repo path.
After that, all required packages should be installed:

```sh
pacman -S python mingw-w64-x86_64-python2 mingw-w64-x86_64-gcc bison cvs diffutils git make \
	patch tar texinfo unzip flex
```

If there is a problem with the encoding with the python tools, run

```sh
export PYTHONIOENCODING=UTF-8
```

## Installing RTEMS - Demo application (rtems-sparc with the sparc/erc32 BSP)

### 1. Installing the RTEMS `sparc` Tool Suite

First, check whether the `rsb` software is set up properly:

```sh
cd $RTEMS_TOOLS/src/rsb/rtems
../source-builder/sb-check
```

A list of available build sats can be shown with with.
```sh
../source-builder/sb-set-builder --list-bsets
```

Installation is performed with the following command
as long as the `RTEMS_TOOLS` variable has been set properly.
Replace 6 with the RTEMS version used. For the git way, 6 was used.

```sh
cd $RTEMS_TOOLS/src/rsb/rtems
../source-builder/sb-set-builder --prefix=$RTEMS_PREFIX $RTEMS_VERSION/rtems-sparc
```

This command will install the tools at the prefix path.
Succesfull installation can be verified with

```sh
$RTEMS_TOOLS/bin/sparc-rtems6-gcc --version
```

### 2. Building the `sparc/erc32` Board Support Package (BSP)

#### Build the BSP from RTEMS sources

The tools required to build `sparc` BSPs have been installed so we can also build the erc32 BSP from sources.

```sh
cd src/rtems
```

Create a `config.ini` file with the following content

```
[sparc/erc32]
BUILD_TESTS = True
```

Run the following command to build the BSP

```sh
./waf configure --prefix=$RTEMS_PREFIX
./waf
./waf install
```


## Installing RTEMS - STM32H743ZI Nucleo (rtems-arm with the arm/stm32h7 BSP)

### 1. Installing the RTEMS `arm` Tool Suite

```sh
cd $RTEMS_TOOLS/src/rsb/rtems
../source_builder/sb-set-builder --prefix=$RTEMS_PREFIX $RTEMS_VERSION/rtems-arm
```

Succesfull installation can be verified with
```sh
$RTEMS_PREFIX/bin/arm-rtems6-gcc --version
```

### 2. Building the `arm/stm32h7` BSP

The BSP can not be built with the source builder and has to be built directly from sources. 
As a first step, the configuration file to configure the BSP build needs to be copied to the 
rtems source.

```sh
cp $RTEMS_TOOLS/samples/arm_stm32/config.ini $RTEMS_TOOLS/src/rtems
```

To display the default BSP configure build options for the specific BSP, the following command 
can be used

```sh
./waf bsp_defaults --rtems-bsp=arm/stm32h7
```

The BSP is built and installed with the waf build system with the 
following commands


```sh
cd $RTEMS_PREFIX/src/rtems
./waf configure --prefix=$RTEMS_PREFIX
./waf
./waf install
```

## Setting up the environment

Lastly, it is recommended to add the following lines to your `.bashrc` or `.profile` file in 
the home directory (Linux, MinGW64) or set them up in your System Environmental variables
(Windows). Replace `$RTEMS_PREFIX` with your RTEMS prefix. This saves you the work of always
having to specify the full path to the toolchain binaries or having to type out the full prefix.

```sh
export RTEMS_VERSION=6
export RTEMS_PREFIX=$RTEMS_PREFIX
export PATH=$PATH:"$RTEMS_PREFIX/bin"
```


