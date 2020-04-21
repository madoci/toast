#!/bin/bash

# Increase MINOR and add "-SNAPSHOT" to POM version

VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

VERSION=${VERSION//./ }         # Split MAJOR, MINOR and PATCH
VERSION=${VERSION//-/ }         # Split apart -SNAPSHOT if any

OldIFS=$IFS
IFS=' '                         # Set space as delimiter
read -ra nums <<< "$VERSION"    # nums is read into an array as tokens separated by IFS
IFS=$OldIFS

lastIndex=$( expr ${#nums[@]} - 1 )

# Don't update version if already a SNAPSHOT
if [ ${nums[$lastIndex]} != "SNAPSHOT" ]
then
  newMINOR=$( expr ${nums[1]} + 1)              # Increase MINOR by 1
  newVERSION="${nums[0]}.$newMINOR-SNAPSHOT"    # Add -SNAPSHOT at the end

  mvn versions:set -DnewVersion=$newVERSION     # Set the new version in POM file
fi
