#!/bin/bash
cpus=`ncpus`
echo "Running on ${cpus} cpus"
rm -rf *
(cmake -DCMAKE_BUILD_TYPE=Debug -DWITH_SSL=system -DWITH_ZLIB=bundled -DMYSQL_MAINTAINER_MODE=0 -DENABLED_LOCAL_INFILE=1 -DENABLE_DTRACE=0 -DCMAKE_CXX_FLAGS="-march=native" -DCMAKE_INSTALL_PREFIX=../facebook-mysql-install -DWITH_PERFSCHEMA_STORAGE_ENGINE=1 ../facebook-mysql && make -j${cpus}) 2>&1 | tee build.log
