#!/bin/bash

version=$(cat .version)

release_version=${version%%-SNAPSHOT}
new_version=$(echo $release_version+0.1 | bc)

[[ $? -ne 0 ]] && echo 'Error exiting.' && exit 1

snapshot_version=${new_version}-SNAPSHOT

cat <<EOF

    current version     : $version
    release version     : $release_version
    new snapshot version: $snapshot_version

EOF

git fetch

echo start the release by creating a new release branch

git checkout -b release/$release_version origin/develop
echo $release_version > ./.version
git add ./.version
git commit -m "[release] prepare release v$release_version"
git tag v$release_version
echo $snapshot_version > ./.version
git add ./.version
git commit -m "[release] prepare for next development iteration"

echo merge the version back into develop
git checkout develop
git merge --no-ff -m "[release] merge release/$release_version into develop" release/$release_version

git checkout master
echo merge the version back into master but use the tagged version instead of the release/$releaseVersion HEAD
git merge --no-ff -m "[release] merge previous version into master to avoid the increased version number" release/$release_version~1

echo get back on the develop branch
git checkout develop
echo finally push everything
git push origin develop master
git push --tags
echo removing the release branch
git branch -D release/$release_version
