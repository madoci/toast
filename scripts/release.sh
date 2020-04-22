#!/bin/bash

if [ $# -gt 1 ]
then
  VERSION=$1
  mvn release:prepare -DnewVersion
else
  POM_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
  DEFAULT_VERSION=${POM_VERSION//-SNAPSHOT/}

  echo "Release version ($DEFAULT_VERSION) :"
  read VERSION
  
  if [ $VERSION == "" ]
  then
    VERSION=$DEFAULT_VERSION
  fi
fi

TAG="v$VERSION"

# Extract version number from tag
VERSION=$TRAVIS_TAG
VERSION=${VERSION//v/}

# Remove tag
git tag -d $TRAVIS_TAG
git push --delete origin-travis $TRAVIS_TAG

# Make sure we are on master and everything is up-to-date
git checkout master
git pull

# Change POM version to release version
mvn versions:set -DnewVersion=$VERSION

# Commit pom.xml
git add pom.xml
git commit -m "Prepare la release $VERSION"

# Push pom.xml
git push --quiet

# Tag the commit
git tag $TRAVIS_TAG
git push --tags
