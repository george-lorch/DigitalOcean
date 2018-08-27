#!/bin/bash
my_mtr.sh --suite=tokudb,tokudb.add_index,tokudb.alter_table,tokudb.bugs,tokudb.parts,tokudb.perfschema,tokudb.rpl,tokudb.sys_vars $@
