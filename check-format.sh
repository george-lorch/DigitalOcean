#!/bin/bash

COMMIT=$1

if [ -z "${COMMIT}" ]; then
    COMMIT="HEAD^1"
fi



git diff -U0 --no-color ${COMMIT} -- *.c *.cc *.cpp *.h *.hpp *.i *.ic *.ih | clang-format-diff.py -binary=clang-format -style=file -p1
