#! /bin/bash

set -e
set -x

eval "$(pyenv init -)"

SCRIPT_DIR="$(cd "$(dirname $0)";$(which pwd))"
ROOT_DIR="$SCRIPT_DIR/.."

cd "$ROOT_DIR"
for PE in 2.7.17 3.5.8 3.6.9 3.7.5 3.8.0;do
  pyenv local $PE
  PIP="$(pyenv which pip)"
  "$PIP" install --upgrade pip
  "$PIP" install wheel
  "$PIP" install --upgrade 'setuptools>=38.6.0'
  "$PIP" wheel . -w wheelhouse/
done
