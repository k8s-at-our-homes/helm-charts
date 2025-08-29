#!/bin/bash

# Test runner for Lua unit tests
# Requires lua to be installed

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="$SCRIPT_DIR/.."

echo "Running Lua unit tests for Photon Response Validator..."
echo "======================================================="

# Check if lua is available
if ! command -v lua &> /dev/null; then
    echo "ERROR: lua command not found. Please install Lua to run the tests."
    echo "On Ubuntu/Debian: apt-get install lua5.3"
    echo "On macOS: brew install lua"
    exit 1
fi

# Run the tests
cd "$CHART_DIR"
lua tests/lua/test-photon-response-validator.lua

echo ""
echo "Tests completed successfully!"