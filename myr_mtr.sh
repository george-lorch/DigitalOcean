#!/bin/bash
if [ -n "${MAX_PARALLEL}" ]; then
    cpus=${MAX_PARALLEL}
else
    cpus=`ncpus`
fi
echo "Running on ${cpus} cpus"

chmod +x ./mysql-test-run.pl
LIBHOTBACKUP=$(find $(readlink -f ..) -type f -name 'libHotBackup.so')
LIBEATMYDATA=$(find /usr/lib -name 'libeatmydata.so' | sort | head -n 1)
if [ -z "$LIBEATMYDATA" ]; then
    echo "****** NO LIBEATMYDATA FOUND ******"
    exit 1
fi

LD_PRELOAD="${LIBEATMYDATA} ${LIBHOTBACKUP}" ./mtr --force --retry=0 --retry-failure=0 --max-test-fail=0 --testcase-timeout=30 --parallel=${cpus} --big-test --suite=rocksdb,rocksdb_rpl,rocksdb.sys_vars $@
