#!/bin/bash

set -e -x
cd /mnt

# Compile wheels
for PYBIN in /opt/python/cp3[!5]*/bin; do
    VERSION="$("$PYBIN/python" --version 2>&1)"
    VERSION="${VERSION#Python }"
    PYTHON="${PYBIN}/python"
    PIP="${PYBIN}/pip"
    "$PIP" install -r dev-requirements.txt
    "$PIP" install --upgrade pip
    WHEEL_NAME="$("$PIP" wheel . -w wheelhouse/ | sed -n -e '/Created wheel for cexprtk:/{s/^.*filename=\(.*\.whl\) .*$/\1/;p;}')"
    
    # Bundle external shared libraries into the wheels
    FIXED_WHEEL="$(auditwheel repair wheelhouse/"$WHEEL_NAME" -w /mnt/wheelhouse/ 2>&1 | sed -n -e 's/^Fixed-up wheel written to \(.*\.whl\)$/\1/p')"
    rm wheelhouse/"$WHEEL_NAME"

    # Test the wheel
    VENV_NAME="${HOME}/manylinux-venv-${VERSION}"
    "$PYTHON" -mvenv "$VENV_NAME"
    source "$VENV_NAME"/bin/activate
    "$VENV_NAME"/bin/pip install --upgrade pip
    "$VENV_NAME"/bin/pip uninstall -y cexprtk
    "$VENV_NAME"/bin/pip install pytest wheel
    "$VENV_NAME"/bin/pip install "$FIXED_WHEEL"
    "$VENV_NAME"/bin/python -mpytest tests
    deactivate
    rm -rf "$VENV_NAME"
done
