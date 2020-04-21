#!/bin/bash

# Push the modified POM with new snapshot version

# Commit pom.xml
git add pom.xml
git commit -m "Prepare la prochaine version de développement (SNAPSHOT)"

# Push pom.xml
git push --quiet
