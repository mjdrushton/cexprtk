#! /bin/bash

set -e
set -x

SCRIPT_DIR="$(cd "$(dirname $0)";$(which pwd))"
ROOT_DIR="$SCRIPT_DIR/.."

cd "$ROOT_DIR"
for PE in 2.7.14 3.3.7 3.4.8 3.5.5 3.6.3 3.6.4 3.6.5 3.7.0;do
  pyenv local $PE
  PIP="$(pyenv which pip)"
  "$PIP" install wheel
  "$PIP" wheel . -w wheelhouse/
done
