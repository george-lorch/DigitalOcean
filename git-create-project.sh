#!/bin/bash

function wait_for_pid_to_disappear() {
    while [ ! -z "`ps -p ${1} -o cmd --no-headers`" ]; do
        sleep 1
    done
}

usage()
{
    echo "Usage:"
    echo "      $0 feature-name"
}

PROJECT=$1

if [ -z "${PROJECT}" ]; then
    usage
    exit 1
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

git clone --recursive https://github.com/georgelorchpercona/myrocks &
clone1=$!

git clone --recursive https://github.com/percona/percona-server &
clone2=$!
mkdir percona-server-build-5.6
mkdir percona-server-build-5.7
mkdir percona-server-build-8.0
mkdir percona-server-install-5.6
mkdir percona-server-install-5.7
mkdir percona-server-install-8.0
mkdir perconaft-build

git clone --recursive https://github.com/facebook/mysql-5.6 facebook-mysql &
clone3=$!
mkdir facebook-mysql-build
mkdir facebook-mysql-install

wait_for_pid_to_disappear $clone1
wait_for_pid_to_disappear $clone2
wait_for_pid_to_disappear $clone3

cd ../${PROJECT}/percona-server
git remote add downstream git@github.com:georgelorchpercona/percona-server
cd -

cd ../${PROJECT}/percona-server/storage/tokudb/PerconaFT
git remote add downstream git@github.com:georgelorchpercona/PerconaFT
cd -

cd ../${PROJECT}/facebook-mysql
git remote add downstream git@github.com:georgelorchpercona/mysql-5.6
cd -

cd ${ORIG_PWD}
