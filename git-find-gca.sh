#!/bin/bash

set -e

finished() {
    git branch
    exit 0
}

SERIES=( "5.6" "5.7" "8.0" )
FEATURE=$1
VERSION=$2

SERIES_TOP=$(( ${#SERIES[@]}-1 ))
HIGHEST_VERSION=${SERIES[$SERIES_TOP]}


for series in ${SERIES}; do
    git checkout ${series}
    git pull
done
git checkout ${HIGHEST_VERSION}
latest_commit=$(git log -n 1 --pretty=format:"%H" ${HIGHEST_VERSION})
echo "latest commit for ${HIGHEST_VERSION} is ${latest_commit}"
for i in $(seq ${SERIES_TOP} -1 1); do
    lower_version=${SERIES[$i-1]}
    commit=$(git rev-list --topo-order --first-parent ${lower_version} ^${HIGHEST_VERSION} | tail -1)
    if [ -z "$commit" ] ; then
        commit=$(git rev-parse ${lower_version}^)
    else
        commit=$(git rev-parse ${commit}^)
    fi
    latest_commit=$(git log -n 1 --pretty=format:"%H" ${lower_version})
    echo "GCA for ${SERIES[${i}]} and ${lower_version} is ${commit}, latest commit for ${lower_version} is ${latest_commit}"
    git checkout ${lower_version}
    HIGHEST_VERSION=$commit
done

finished
