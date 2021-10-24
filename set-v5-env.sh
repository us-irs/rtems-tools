#!/bin/bash -i
echo "Entering RTEMS 5 environment"

export RTEMS_VERSION=5
export PATH="$PATH":"$(pwd)/rtems/$RTEMS_VERSION/bin"
export RTEMS_PREFIX="$(pwd)/rtems/$RTEMS_VERSION"

export CONSOLE_PREFIX="[RTEMS 5]"
exec /bin/bash
