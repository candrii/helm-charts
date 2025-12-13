#!/bin/bash
# Bump patch version in Chart.yaml for the chart containing the updated file
# Usage: bump-chart-version.sh <file-path>

FILE="$1"
if [ -z "$FILE" ]; then
  echo "Usage: $0 <file-path>"
  exit 1
fi

# Find the chart directory (contains Chart.yaml)
DIR=$(dirname "$FILE")
while [ "$DIR" != "." ] && [ "$DIR" != "/" ]; do
  if [ -f "$DIR/Chart.yaml" ]; then
    CHART_YAML="$DIR/Chart.yaml"
    break
  fi
  DIR=$(dirname "$DIR")
done

if [ -z "$CHART_YAML" ]; then
  echo "No Chart.yaml found for $FILE"
  exit 0
fi

# Get current version
VERSION=$(grep '^version:' "$CHART_YAML" | sed 's/version:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}/\1/')

if [ -z "$VERSION" ]; then
  echo "Could not parse version from $CHART_YAML"
  exit 1
fi

# Bump patch version
MAJOR=$(echo "$VERSION" | cut -d. -f1)
MINOR=$(echo "$VERSION" | cut -d. -f2)
PATCH=$(echo "$VERSION" | cut -d. -f3)
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH"

# Update Chart.yaml
sed -i "s/^version:.*/version: \"$NEW_VERSION\"/" "$CHART_YAML"

echo "Bumped $CHART_YAML: $VERSION -> $NEW_VERSION"
