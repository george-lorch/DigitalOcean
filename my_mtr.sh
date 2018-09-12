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
LIBASAN=$(find /usr/lib -name 'libasan.so' | sort | head -n 1)
if [ -z "${LIBEATMYDATA}" ]; then
    echo "****** NO LIBEATMYDATA FOUND ******"
    exit 1
fi

PRELOAD="${LIBEATMYDATA}:${LIBHOTBACKUP}"

echo $@ | grep "sanitize" > /dev/null
if [ $? -eq 0 ]; then
    if [ -z "${LIBASAN}" ]; then
        echo "****** --sanitize specified but no libasan.so found ******"
        exit 1
    fi
    PRELOAD="${LIBASAN}:${PRELOAD}"
fi

echo ./mtr --force --retry=0 --retry-failure=0 --max-test-fail=0 --testcase-timeout=120 --mysqld=--loose-tokudb-cache-size=512M --mysqld-env="LD_PRELOAD=${PRELOAD}" --parallel=${cpus} $@
