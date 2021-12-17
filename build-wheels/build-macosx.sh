#! /bin/bash

set -e
set -x

eval "$(pyenv init -)"

SCRIPT_DIR="$(cd "$(dirname $0)";$(which pwd))"
ROOT_DIR="$SCRIPT_DIR/.."

cd "$ROOT_DIR"
for PE in 3.9.9 3.6.10 3.7.12 3.8.12;do
  pyenv local $PE
  PIP="$(pyenv which pip)"
  "$PIP" install --upgrade pip
  "$PIP" install wheel
  "$PIP" install --upgrade 'setuptools>=38.6.0'
  "$PIP" wheel . -w wheelhouse/
done
