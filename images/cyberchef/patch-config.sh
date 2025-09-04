#!/bin/sh
set -eu

# Patch CyberChef default options to disable updateUrl for self-hosted environments
# This script modifies the minified main.js file to set updateUrl to false

HTML_DIR="${1:-/usr/share/nginx/html}"
MAIN_JS="${HTML_DIR}/assets/main.js"

if [ ! -f "$MAIN_JS" ]; then
    echo "Error: main.js not found at $MAIN_JS"
    exit 1
fi

echo "Patching CyberChef default options in $MAIN_JS"

# Replace updateUrl:!0 with updateUrl:!1 (minified true -> false)
# This disables the update URL check for self-hosted environments
sed -i 's/updateUrl:!0,/updateUrl:!1,/g' "$MAIN_JS"

# Verify the patch was applied
if grep -q "updateUrl:!1," "$MAIN_JS"; then
    echo "Successfully patched updateUrl to false"
else
    echo "Error: Failed to apply patch"
    exit 1
fi

echo "Patch applied successfully"