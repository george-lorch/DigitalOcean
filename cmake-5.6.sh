#!/bin/bash
if [ -n "${MAX_PARALLEL}" ]; then
    cpus=${MAX_PARALLEL}
else
    cpus=`ncpus`
fi
echo "Running on ${cpus} cpus"
rm -rf *
(cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../percona-server-install-5.6 -DMYSQL_MAINTAINER_MODE=ON $@ ../percona-server-5.6 && make -j${cpus} install) 2>&1 | tee build.log
