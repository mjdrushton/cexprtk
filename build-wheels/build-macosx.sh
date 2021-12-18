#! /bin/bash

set -e
set -x

eval "$(pyenv init -)"

SCRIPT_DIR="$(cd "$(dirname $0)";$(which pwd))"
ROOT_DIR="$SCRIPT_DIR/.."
ENVS="$(pyenv local | xargs echo)"

cd "$ROOT_DIR"
for PE in 3.9.9 3.6.10 3.7.12 3.8.12;do
  pyenv local $PE
  PIP="$(pyenv which pip)"
  "$PIP" install --upgrade pip
  "$PIP" install wheel
  "$PIP" install --upgrade 'setuptools>=38.6.0'
  WHEEL_NAME="$("$PIP" wheel . -w wheelhouse/ | sed -n -e '/Created wheel for cexprtk:/{s/^.*filename=\(.*\.whl\) .*$/\1/;p;}')"

  # Test the wheel
  "$PIP" install pytest
  "$PIP" uninstall -y cexprtk
  "$PIP" install wheelhouse/"$WHEEL_NAME"
  "$(pyenv which pytest)" tests

done

# Restore pyenv set-up
pyenv local $ENVS