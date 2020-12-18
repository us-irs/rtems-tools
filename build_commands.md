## Build Commands RSB

### Cross-Compiling

#### ARM

../source-builder/sb-set-builder --prefix=$RTEMS_TOOLS 6/rtems-arm

#### SPARC

../source-builder/sb-set-builder --prefix=$RTEMS_TOOLS 6/rtems-sparc

### Canadian Cross-Compiling (CXC)

#### SPARC, Windows x86_64 Host:

../source-builder/sb-set-builder --prefix=/rtems/6 --no-install --bset-tar-file --host=x86_64-w64-mingw32 6/rtems-sparc

#### SPARC, Windows i686 Host:

../source-builder/sb-set-builder --prefix=/rtems/6 --no-install --bset-tar-file --host=i686-w64-mingw32 6/rtems-sparc

#### ARM, Windows x86_64 Host:

../source-builder/sb-set-builder --prefix=/rtems/6 --no-install --bset-tar-file --host=x86_64-w64-mingw32 6/rtems-arm

