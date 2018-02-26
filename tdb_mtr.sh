#!/bin/bash
cpus=`ncpus`
echo "Running on ${cpus} cpus"

chmod +x ./mysql-test-run.pl
LIBHOTBACKUP=$(find $(readlink -f ..) -type f -name 'libHotBackup.so')
LIBEATMYDATA=$(find /usr/lib -name 'libeatmydata.so' | sort | head -n 1)
if [ -z "$LIBEATMYDATA" ]; then
    echo "****** NO LIBEATMYDATA FOUND ******"
    exit 1
fi

LD_PRELOAD="${LIBEATMYDATA} ${LIBHOTBACKUP}" ./mtr --force --retry=0 --retry-failure=0 --max-test-fail=0 --testcase-timeout=30 --mysqld=--loose-tokudb-cache-size=512M --parallel=${cpus} --big-test --suite=tokudb,tokudb.add_index,tokudb.alter_table,tokudb.bugs,tokudb.parts,tokudb.perfschema,tokudb.rpl,tokudb.sys_vars $@
