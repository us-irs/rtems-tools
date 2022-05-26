#!/bin/bash -i
echo "Entering RTEMS 6 environment"

export RTEMS_VERSION=6
export PATH="$PATH":"$(pwd)/rtems/$RTEMS_VERSION/bin"
export RTEMS_PREFIX="$(pwd)/rtems/$RTEMS_VERSION"

export CONSOLE_PREFIX="[RTEMS 6]"
exec /bin/bash
