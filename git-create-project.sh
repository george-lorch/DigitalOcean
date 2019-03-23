#!/bin/bash

function wait_for_pid_to_disappear() {
    while [ ! -z "`ps -p ${1} -o cmd --no-headers`" ]; do
        sleep 1
    done
}

function usage()
{
    echo "Usage:"
    echo "      feature-name"
    echo "      use-git-protocol"
}

PROJECT=$1

if [ -z "${PROJECT}" ]; then
    usage
    exit 1
fi

PROTOCOL="https://github.com/"
if [ -n "${2}" ]; then
    PROTOCOL="git@github.com:"
fi

if [ -d "./${PROJECT}" ]; then
    echo "Project ./${PROJECT} already exists. Aborting"
    exit 1
else
    echo "Project ./${PROJECT} does not exist. Proceeding"
fi

ORIG_PWD=${PWD}

if [ ! -d "boost_1_59_0" ]; then
    echo "Requires boost_1_59_0 be present in ${PWD}"
    exit 1
fi

if [ ! -d "boost_1_66_0" ]; then
    echo "Requires boost_1_66_0 be present in ${PWD}"
    exit 1
fi

mkdir ./${PROJECT}
cd ./${PROJECT}

ln -s ../boost_1_59_0
ln -s ../boost_1_65_0
ln -s ../boost_1_66_0
ln -s ../boost_1_67_0
ln -s ../boost_1_68_0

unset pids;
pid_idx=1

git clone --recursive ${PROTOCOL}georgelorchpercona/myrocks &
pids[${pid_idx}]=$!
pid_idx=`expr ${pid_idx} + 1`

git clone --recursive ${PROTOCOL}percona/percona-server -b 5.6 percona-server-5.6 &
pids[${pid_idx}]=$!
pid_idx=`expr ${pid_idx} + 1`

git clone --recursive ${PROTOCOL}percona/percona-server -b 5.7 percona-server-5.7 &
pids[${pid_idx}]=$!
pid_idx=`expr ${pid_idx} + 1`

git clone --recursive ${PROTOCOL}percona/percona-server -b 8.0 percona-server-8.0 &
pids[${pid_idx}]=$!
pid_idx=`expr ${pid_idx} + 1`

git clone --recursive https://github.com/facebook/mysql-5.6 facebook-mysql &
pids[${pid_idx}]=$!
pid_idx=`expr ${pid_idx} + 1`

mkdir percona-server-build-5.6
mkdir percona-server-install-5.6

mkdir percona-server-build-5.7
mkdir percona-server-install-5.7

mkdir percona-server-build-8.0
mkdir percona-server-install-8.0

mkdir facebook-mysql-build
mkdir facebook-mysql-install

for ((i=1; i<${pid_idx}; i++)); do
    wait_for_pid_to_disappear ${pids[${i}]}
done

unset pids
unset pid_idx

cd ../${PROJECT}/percona-server-5.6
git remote add downstream ${PROTOCOL}georgelorchpercona/percona-server
git remote add local-5.7 ../percona-server-5.7
git remote add local-8.0 ../percona-server-8.0
git remote add local-fb ../facebook-mysql
cd -

cd ../${PROJECT}/percona-server-5.7
git remote add downstream ${PROTOCOL}georgelorchpercona/percona-server
git remote add local-5.6 ../percona-server-5.6
git remote add local-8.0 ../percona-server-8.0
git remote add local-fb ../facebook-mysql
cd -

cd ../${PROJECT}/percona-server-8.0
git remote add downstream ${PROTOCOL}georgelorchpercona/percona-server
git remote add local-5.6 ../percona-server-5.6
git remote add local-5.7 ../percona-server-5.7
git remote add local-fb ../facebook-mysql
cd -

cd ../${PROJECT}/percona-server-5.6/storage/tokudb/PerconaFT
git remote add downstream ${PROTOCOL}georgelorchpercona/PerconaFT
cd -

cd ../${PROJECT}/percona-server-5.7/storage/tokudb/PerconaFT
git remote add downstream ${PROTOCOL}georgelorchpercona/PerconaFT
cd -

cd ../${PROJECT}/percona-server-8.0/storage/tokudb/PerconaFT
git remote add downstream ${PROTOCOL}georgelorchpercona/PerconaFT
cd -

cd ../${PROJECT}/facebook-mysql
git remote add downstream ${PROTOCOL}georgelorchpercona/mysql-5.6
git remote add local-5.6 ../percona-server-5.6
git remote add local-5.7 ../percona-server-5.7
git remote add local-8.0 ../percona-server-8.0
cd -

cd ${ORIG_PWD}
