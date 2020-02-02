#!/bin/bash
suite=$1
shift
tests=$@

cmd="my_mtr.sh --suite=${suite} --record --big-test"
for t in ${tests}; do
    cmd="${cmd} ${t}.test"
done

$cmd

for t in ${tests}; do
    cp suite/${suite}/r/${t}.result ../../percona-server-8.0/mysql-test/suite/${suite}/r
done
