#! /bin/bash
set -e 
set -x

SCRIPT_DIR="$(cd "$(dirname $0)";$(which pwd))"
ROOT_DIR="$SCRIPT_DIR/.."
DOCKER_IMAGE_64=quay.io/pypa/manylinux1_x86_64
DOCKER_IMAGE_32=quay.io/pypa/manylinux1_i686

docker run -m 6G --cpus=2 --rm -v "$ROOT_DIR":/mnt -ti $DOCKER_IMAGE_32 linux32 /mnt/build-wheels/manylinux/build-wheels.sh
docker run -m 6G --cpus=2 --rm -v "$ROOT_DIR":/mnt -ti $DOCKER_IMAGE_64 /mnt/build-wheels/manylinux/build-wheels.sh