#!/bin/bash

# Get current version from pubspec.yaml
CURRENT_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //')
IFS='+' read -ra VERSION_PARTS <<< "$CURRENT_VERSION"
VERSION_NAME=${VERSION_PARTS[0]}
VERSION_CODE=${VERSION_PARTS[1]}

# Calculate new version code
NEW_VERSION_CODE=$((VERSION_CODE + 1))
NEW_VERSION="$VERSION_NAME+$NEW_VERSION_CODE"

# Update pubspec.yaml
sed -i "s/^version: .*/version: $NEW_VERSION/" pubspec.yaml

echo "Updated version to: $NEW_VERSION"
