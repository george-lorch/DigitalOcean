#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: create_my_cnf.sh BASEDIR"
	echo "Creates my.cnf file and associated directories necessay if they do not exist."
	echo "Assumes that BASEDIR is the location of mysql as a result of a 'make install'."
	exit 1
fi

BASEDIR=$1
shift

DATADIR=${DATADIR:-${BASEDIR}/data}
ETCDIR=${ETCDIR:-${BASEDIR}/etc}
TMPDIR=${TMPDIR:-${BASEDIR}/tmp}
VARDIR=${VARDIR:-${BASEDIR}/var}
PORT=${PORT:-10000}
SOCKETFILE=${SOCKETFILE:-${VARDIR}/mysql.sock}
PIDFILE=${PIDFILE:-${VARDIR}/mysql.pid}
DEFAULTSFILE=${DEFAULTSFILE:-${ETCDIR}/my.cnf}
SERVERID=${SERVERID:-"1"}
RUNMYSQLD=${BASEDIR}/runmysqld.sh
GDBMYSQLD=${BASEDIR}/gdbmysqld.sh
RUNMYSQL=${BASEDIR}/runmysql.sh
RUNMYSQLADMIN=${BASEDIR}/runmysqladmin.sh

if [ ! -d "${BASEDIR}" ]; then
	echo "Invalid BASEDIR specified \"${BASEDIR}\""
	exit 1
fi

if [ ! -d "${ETCDIR}" ]; then
	mkdir ${ETCDIR}
	if [ $? -ne 0 ]; then
		echo "Creation of ETCDIR \"${ETCDIR}\" failed with $?"
		exit 1
	fi
	echo "Created \"${ETCDIR}\""
fi
if [ ! -d "${TMPDIR}" ]; then
	mkdir ${TMPDIR}
	if [ $? -ne 0 ]; then
		echo "Creation of TMPDIR \"${TMPDIR}\" failed with $?"
		exit 1
	fi
	echo "Created \"${TMPDIR}\""
fi
if [ ! -d "${VARDIR}" ]; then
	mkdir ${VARDIR}
	if [ $? -ne 0 ]; then
		echo "Creation of VARDIR \"${VARDIR}\" failed with $?"
		exit 1
	fi
	echo "Created \"${VARDIR}\""
fi

cat > ${DEFAULTSFILE} <<EOF
[client]
port=${PORT}
socket=${SOCKETFILE}
user=root

[mysqld]
basedir=${BASEDIR}
datadir=${DATADIR}
tmpdir=${TMPDIR}
port=${PORT}
socket=${SOCKETFILE}
pid-file=${PIDFILE}
console
server-id=${SERVERID}
max_connections=1000
rocksdb
default-storage-engine=rocksdb
skip-innodb
default-tmp-storage-engine=MyISAM
EOF

for option in $@; do
	echo "${option}" >> ${DEFAULTSFILE}
done

echo "Wrote out \"${DEFAULTSFILE}\" with contents:"
cat ${DEFAULTSFILE}

cat > ${GDBMYSQLD} <<EOF
#!/bin/bash
LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.1 ${BASEDIR}/lib/libHotBackup.so" gdb --args ${BASEDIR}/bin/mysqld --defaults-file=${DEFAULTSFILE} \$@
EOF
chmod +x ${GDBMYSQLD}

cat > ${RUNMYSQLD} <<EOF
#!/bin/bash
LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libjemalloc.so.1 ${BASEDIR}/lib/libHotBackup.so" ${BASEDIR}/bin/mysqld --defaults-file=${DEFAULTSFILE} \$@
EOF
chmod +x ${RUNMYSQLD}

cat > ${RUNMYSQL} <<EOF
#!/bin/bash
${BASEDIR}/bin/mysql --defaults-file=${DEFAULTSFILE} \$@
EOF
chmod +x ${RUNMYSQL}

cat > ${RUNMYSQLADMIN} <<EOF
#!/bin/bash
${BASEDIR}/bin/mysqladmin --defaults-file=${DEFAULTSFILE} \$@
EOF
chmod +x ${RUNMYSQLADMIN}


rm -rf ${DATADIR}/*
./scripts/mysql_install_db --defaults-file=${PWD}/etc/my.cnf


