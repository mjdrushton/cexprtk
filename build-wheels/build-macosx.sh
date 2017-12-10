#! /bin/bash

set -e
set -x

SCRIPT_DIR="$(cd "$(dirname $0)";$(which pwd))"
ROOT_DIR="$SCRIPT_DIR/.."

cd "$ROOT_DIR"
for PE in 3.5.4 3.6.3 3.7.0a1;do
  pyenv local $PE
  PIP="$(pyenv which pip)"
  "$PIP" install wheel
  "$PIP" wheel . -w wheelhouse/
done