#!/bin/bash
if [ -n "${MAX_PARALLEL}" ]; then
    cpus=${MAX_PARALLEL}
else
    cpus=`ncpus`
fi
echo "Running on ${cpus} cpus"
rm -rf *
(cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../percona-server-install-5.7 -DMYSQL_MAINTAINER_MODE=OFF -DWITH_EMBEDDED_SERVER=ON -DWITH_KEYRING_VAULT=OFF -DWITH_JEMALLOC=system -DWITH_BOOST=../boost_1_59_0 -DZLIB_INCLUDE_DIR=/usr/include/ $@ ../percona-server-5.7 && make -j${cpus}) 2>&1 | tee build.log
