#!/bin/bash

# Extracting current version from POM and deducing release version
POM_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
DEFAULT_VERSION=${POM_VERSION//-SNAPSHOT/}

# Ask for release version
echo -n "Release version ? ($DEFAULT_VERSION) : "; read version
if [ -z $version ]
then
    version=$DEFAULT_VERSION
fi

# Default tag is prefixed by 'v'
DEFAULT_TAG="v$version"

# Ask for release tag
echo -n "Release tag ? ($DEFAULT_TAG) : "; read tag
if [ -z $tag ]
then
    tag=$DEFAULT_TAG
fi

# Deduce next development version
SPLIT_VERSION=${version//./ }
IFS=' '
read -ra SPLIT_VERSION <<< "$SPLIT_VERSION"
NEW_MINOR=$( expr ${SPLIT_VERSION[1]} + 1 )
DEFAULT_SNAPSHOT="${SPLIT_VERSION[0]}.$NEW_MINOR-SNAPSHOT"

echo -n "Next development version ? ($DEFAULT_SNAPSHOT) : "; read snapshot
if [ -z $snapshot ]
then
    snapshot=$DEFAULT_SNAPSHOT
fi

echo "Preparing release $version with tag $tag"

# Make sure we are on master and everything is up-to-date
git checkout master
git pull

# Set the release version in POM file
mvn versions:set -DnewVersion=$version

# Commit new POM
git add .
git commit -m "Prepare release $version"
git push

# Tag release
git tag $tag
git push --tags

echo "Preparing next release $version with tag $tag"

# Set the next development version in POM file
mvn versions:set -DnewVersion=$snapshot

# Commit new POM
git add .
git commit -m "Prepare for next development version $snapshot"
git push
