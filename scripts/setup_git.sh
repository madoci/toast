#!/bin/bash

# Configure git user
git config --global user.email "travis@travis-ci.com"
git config --global user.name "Travis CI"

# Move to master
git checkout -b master

# Add remote url with access token
git remote add origin-travis https://${GITHUB_TOKEN}@github.com/madoci/toast.git

# Link the local branch master to the remote one
git push --set-upstream origin-travis master
