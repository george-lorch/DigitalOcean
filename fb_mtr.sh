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

LD_PRELOAD="${LIBEATMYDATA} ${LIBHOTBACKUP}" ./mtr --force --retry=0 --retry-failure=0 --max-test-fail=0 --no-warnings --testcase-timeout=600 --mysqld=--rocksdb --mysqld=--default-storage-engine=rocksdb --mysqld=--skip-innodb --mysqld=--default-tmp-storage-engine=MyISAM --parallel=${cpus} $@
