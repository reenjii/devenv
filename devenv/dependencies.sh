#!/bin/bash

# Scans tools downloaded from github in Dockerfile and looks for updates.

IFS=$'\n'
for line in $(grep -E "https://github.com/.*/releases/" Dockerfile); do
    REPO=$(echo $line | cut -d '/' -f 4,5)
    echo $REPO
    VERSION_VAR=$(echo $line | sed -e 's/.*{\(.*_VERSION\)}.*/\1/')
    VERSION=$(grep -E "$VERSION_VAR" Dockerfile | head -1 | cut -d '=' -f 2)
    CURRENT=$(echo $line | cut -f 3 -d ' ' | sed "s/\${$VERSION_VAR}/$VERSION/g")
    echo "  current" $CURRENT
    echo "  latest"
    curl -s "https://api.github.com/repos/$REPO/releases/latest" | \
        jq -r '.assets[] | select(.name | contains("inux") and contains("64")) | .browser_download_url'
    break
done
