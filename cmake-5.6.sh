#!/bin/bash
cpus=`ncpus`
echo "Running on ${cpus} cpus"
rm -rf *
(cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=../percona-server-install-5.6 -DMYSQL_MAINTAINER_MODE=OFF $@ ../percona-server && make -j${cpus} install) 2>&1 | tee build.log
