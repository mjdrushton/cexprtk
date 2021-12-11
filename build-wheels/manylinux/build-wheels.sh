#!/bin/bash
set -e -x
cd /mnt

# Compile wheels
for PYBIN in /opt/python/cp3[!5]*/bin; do
    VERSION="$("$PYBIN/python" --version 2>&1)"
    VERSION="${VERSION#Python }"
    "${PYBIN}/pip" install -r dev-requirements.txt
    "${PYBIN}/pip" wheel . -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*-linux_`arch`.whl; do
    auditwheel repair "$whl" -w /mnt/wheelhouse/
done