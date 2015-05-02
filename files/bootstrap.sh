#/bin/bash

set -e

cd

if [[ -e /opt/.bootstrapped ]]; then
  exit 0
fi

PYPY_VERSION=2.4.0

wget -O - https://bitbucket.org/pypy/pypy/downloads/pypy-$PYPY_VERSION-linux64.tar.bz2 |tar -xjf -
mv -n pypy-$PYPY_VERSION-linux64 pypy

## library fixup
mkdir -p pypy/lib
ln -snf /lib64/libncurses.so.5.9 /opt/pypy/lib/libtinfo.so.5

mkdir -p /opt/bin

cat > /opt/bin/python <<EOF
#!/bin/bash
LD_LIBRARY_PATH=/opt/pypy/lib:$LD_LIBRARY_PATH exec /opt/pypy/bin/pypy "\$@"
EOF

chmod +x /opt/bin/python
/opt/bin/python --version

touch /opt/.bootstrapped
