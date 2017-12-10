#! /bin/bash
set -e 
set -x

SCRIPT_DIR="$(cd "$(dirname $0)";$(which pwd))"
ROOT_DIR="$SCRIPT_DIR/.."
DOCKER_IMAGE_64=quay.io/pypa/manylinux1_x86_64
DOCKER_IMAGE_32=quay.io/pypa/manylinux1_i686

if (docker-machine status manylinux); then
  if [ "$(docker-machine status manylinux)" = Stopped ];then
    docker-machine start manylinux
  fi
else
  docker-machine create --driver=virtualbox --virtualbox-memory=6000 --virtualbox-cpu-count=2 manylinux
fi

eval $(docker-machine env manylinux)
docker run --rm -v "$ROOT_DIR":/mnt -ti $DOCKER_IMAGE_32 linux32 /mnt/build-wheels/manylinux/build-wheels.sh
docker run --rm -v "$ROOT_DIR":/mnt -ti $DOCKER_IMAGE_64 /mnt/build-wheels/manylinux/build-wheels.sh