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

# Extracting project name from POM and deducing release name
PROJECT_NAME=$(mvn help:evaluate -Dexpression=project.name -q -DforceStdout)
DEFAULT_NAME="$PROJECT_NAME $version"

echo -n "Release name ? ($DEFAULT_NAME) : "; read name
if [ -z $name ]
then
    name=$DEFAULT_NAME
fi

echo "Preparing release $version as \"$name\" with tag $tag"

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
git tag -a $tag -m $name
git push --tags
