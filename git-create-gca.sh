#!/bin/bash

set -e

usage() {
    echo "Usage:"
    echo "      $0 feature-name version"
}

finished() {
    git branch
    exit 0
}

SERIES=( "5.6" "5.7" "8.0" )
FEATURE=$1
VERSION=$2

SERIES_TOP=$(( ${#SERIES[@]}-1 ))
HIGHEST_VERSION=${SERIES[$SERIES_TOP]}


if [ -z "${FEATURE}" ]; then
    usage
    exit 1
fi

if [ -z "${VERSION}" ]; then
    usage
    exit 1
fi

found=0
for i in $(seq ${SERIES_TOP} -1 0); do
    if [ "${SERIES[${i}]}" = "${VERSION}" ]; then
        found=1
        break
    fi
done

if [ ${found} -eq 0 ]; then
    echo "Unrecognized version \"${VERSION}\""
    usage
    exit 1
fi

for i in `seq 0 ${SERIES_TOP}`; do
    if [ -n "`git branch --list ps-${SERIES[$i]}-${FEATURE}`" ]; then
        echo "Feature branch ps-${SERIES[$i]}-${FEATURE} already exists. Aborting"
        exit 1
    else
        echo "Feature branch ps-${SERIES[$i]}-${FEATURE} does not exist."
    fi
done

for series in ${SERIES}; do
    git checkout ${series}
    git pull
done
git checkout ${HIGHEST_VERSION}
if [ "${VERSION}" = "${HIGHEST_VERSION}" ]; then
    git checkout -b ps-${HIGHEST_VERSION}-${FEATURE}
    finished
fi
latest_commit=$(git log -n 1 --pretty=format:"%H" ${HIGHEST_VERSION})
echo "latest commit for ${HIGHEST_VERSION} is ${latest_commit}"
for i in $(seq ${SERIES_TOP} -1 1); do
    lower_version=${SERIES[$i-1]}
    #commit=$(git merge-base ${HIGHEST_VERSION} ${lower_version})
    commit=$(git rev-list --topo-order --first-parent ${lower_version} ^${HIGHEST_VERSION} | tail -1)
    if [ -z "$commit" ] ; then
        commit=$(git rev-parse ${lower_version}^)
    else
        commit=$(git rev-parse ${commit}^)
    fi
    latest_commit=$(git log -n 1 --pretty=format:"%H" ${lower_version})
    echo "GCA for ${SERIES[${i}]} and ${lower_version} is ${commit}, latest commit for ${lower_version} is ${latest_commit}"
    git checkout ${lower_version}
    if [ "${VERSION}" = "${lower_version}" ]; then
        git checkout -b ps-${lower_version}-${FEATURE} ${commit}
        finished
    fi
    HIGHEST_VERSION=$commit
done

finished
