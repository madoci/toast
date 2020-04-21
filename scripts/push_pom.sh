#!/bin/bash

# Push pom.xml file on github

# Configure git
git config --global user.email "travis@travis-ci.com"
git config --global user.name "Travis CI"
git checkout -b master

# Commit pom.xml
git add pom.xml
git commit -m "Prepare next release"

# Push pom.xml
git remote set-url origin https://${GH_TOKEN}@github.com/madoci/toast.git
git push --quiet --set-upstream origin master
