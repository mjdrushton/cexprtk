#!/bin/bash
set -e -x
cd /mnt

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    VERSION="$("$PYBIN/python" --version 2>&1)"
    VERSION="${VERSION#Python }"
    if [[ $VERSION == 2.6* ]];then
        continue
    fi
    "${PYBIN}/pip" install -r dev-requirements.txt
    "${PYBIN}/pip" wheel . -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /mnt/wheelhouse/
done