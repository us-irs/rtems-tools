## Building RTEMS

I built the RTEMS toolchain in this folder like
specified in the [Quick Start](https://docs.rtems.org/branches/master/user/start/index.html).

The toolchain path inside the repository will be referred with `$RTEMS_TOOLS`.
The RTEMS version number will be referred to as `$RTEMS_VERSION`.
The path where the RTEMS Toolchains will be installed will be referred to as `$RTEMS_INST`.

## Prerequisites

### Ubuntu
Flex and Bison are used. Furthermore, the python-dev package should be installed.

```sh
sudo apt-get install flex bison python-dev
```

### Windows

RTEMS recommends to use MinGW64 so it is recommended to [install it](https://www.msys2.org/).
After that, it is recommended to set an alias in `.bashrc` to the RTEMS repo path.
After that, all required packages should be installed:

```sh
pacman -S python mingw-w64-x86_64-python2 mingw-w64-x86_64-gcc bison cvs diffutils git make patch tar texinfo unzip flex
```

If there is a problem with the encoding with the python tools, run

```sh
export PYTHONIOENCODING=UTF-8
```

## Installing RTEMS - Demo application

### 1. Setting installation prefix

Set the installation prefix. In this case, use the current folder
and run the following command inside the `$RTEMS_TOOLS` path.
When using the git sources directly, it is recommended to take the RTEMS version 6.

```sh
export RTEMS_INST=$(pwd)/rtems/$RTEMS_VERSION
```

Test with `echo $RTEMS_INST`

### 2. Obtain the sources

I used the Releases for now as specified in 
[the quickstart guide](https://docs.rtems.org/branches/master/user/start/sources.html).
Navigate into `$RTEMS_TOOLS` first.

#### Way 1: Git
```sh
mkdir src
cd src
git clone git://git.rtems.org/rtems-source-builder.git rsb
git clone git://git.rtems.org/rtems.git
```

#### Way 2: Package
```sh
mkdir src
cd src
curl https://ftp.rtems.org/pub/rtems/releases/5/5.1/sources/rtems-source-builder-5.1.tar.xz | tar xJf -
```

After that, the folder can be renamed 
```sh
mv rtems-source-builder5.1 rsb
```

### 3. Installing the RTEMS sparc Tool Suite

A list of available build sats can be shown with with
```sh
cd $RTEMS_TOOLS/src/rsb/rtems
../source-builder/sb-set-builder --list-bsets
```

Installation is performed with the following command
as long as the `RTEMS_INST` variable has been set properly.
Replace 6 with the RTEMS version used. For the git way, 6 was used.

```sh
cd $RTEMS_TOOLS/src/rsb/rtems
../source-builder/sb-set-builder --prefix=$RTEMS_INST $RTEMS_VERSION/rtems-sparc
```

Succesfull installation can be verified with
```sh
$RTEMS_INST/bin/sparc-rtems<version>-gcc --version
```

### 4. Building the erc32 Board Support Package (BSP)

After installing the tool suite for the sparc architecture, the BSP for `erc32` should be built to produce binaries which can be run with the `erc32-sis` simulator.

The `sparc/erc32` BSP can be built with the following command (replace 6 with whatever version number is used). Building the test is optional:

```sh
cd $RTEMS_TOOLS/src/rsb/rtems
../source-builder/sb-set-builder --prefix=$RTEMS_INST --target=sparc-rtems6 --with-rtems-bsp=erc32 --with-rtems-tests=yes 6/rtems-kernel
```

The BSP tests can be run with the following command

```sh
cd $RTEMS_INST
bin/rtems-test --rtems-bsp=erc32-sis sparc-rtems6/erc32/tests
```

## Installing RTEMS - STM32H743ZI Nucleo Blinky

Step 1 and step 2 are identical to the steps for the hello program, but the git way has to be used because the arm/stm32h7 BSP can only be found in the master branch of RTEMS. Also, it is recommended to 
clone a fork of the RTEMS repo to get the correct configuration for the nucleo board:

```sh
git clone https://github.com/rmspacefish/rtems.git
```

### 3. Installing the RTEMS arm Tool Suite

```sh
cd $RTEMS_TOOLS/src/rsb/rtems
../source_builder/sb-set-builder --prefix=$RTEMS_INST $RTEMS_VERSION/rtems-arm
```

Succesfull installation can be verified with
```sh
$RTEMS_INST/bin/arm-rtems<version>-gcc --version
```

### 4. Building the stm32h7 BSP

The BSP can not be built with the source builder and has to be built directly from sources. As a first step, the configuration file to configure the BSP build needs to be copied to the rtems source.

```sh
cp $RTEMS_TOOLS/samples/arm_stm32/config.ini $RTEMS_TOOLS/src/rtems
```
To display the default BSP configure build options for the specific BSP, the following command can be used

```sh
./waf bsp_defaults --rtems-bsp=arm/stm32h7
```

The BSP is built and installed with the waf build system with the 
following commands


```sh
cd $RTEMS_TOOLS/src/rtems
./waf configure --prefix=$RTEMS_INST 
./waf
./waf install
```

