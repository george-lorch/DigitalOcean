#!/bin/bash

set -e

usage()
{
    echo "Usage:"
    echo "      $0 feature-name"
}

SERIES=( "5.6" "5.7" )
FEATURE=$1

array_top=$(( ${#SERIES[@]}-1 ))
upper_version=${SERIES[$array_top]}

for i in `seq 0 ${array_top}`; do
    if [ -n "`git branch --list ps-${SERIES[$i]}-${FEATURE}`" ]; then
        echo "Feature branch ps-${SERIES[$i]}-${FEATURE} already exists. Aborting"
        exit 1
    else
        echo "Feature branch ps-${SERIES[$i]}-${FEATURE} does not exist."
    fi
done

for series in ${SERIES}; do
    git checkout ${series}
done
git checkout ${upper_version}
git checkout -b ps-${upper_version}-${FEATURE}
latest_commit=$(git log -n 1 --pretty=format:"%H" ${upper_version})
echo "latest commit for ${upper_version} is ${latest_commit}"
for i in $(seq ${array_top} -1 1) ; do
    lower_version=${SERIES[$i-1]}
    #commit=$(git merge-base ${upper_version} ${lower_version})
    commit=$(git rev-list --topo-order --first-parent ${lower_version} ^${upper_version} | tail -1)
    if [ -z "$commit" ] ; then
        commit=${lower_version}
    else
        commit=$(git rev-parse ${commit}^)
    fi
    latest_commit=$(git log -n 1 --pretty=format:"%H" ${lower_version})
    echo "GCA for ${upper_version} and ${lower_version} is ${commit}, latest commit for ${lower_version} is ${latest_commit}"
    git checkout ${lower_version}
    git checkout -b ps-${lower_version}-${FEATURE} ${commit}
    upper_version=$commit
done

git branch
