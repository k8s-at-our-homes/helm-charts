# Photon Gateway Testing

This directory contains unit tests for the Photon Gateway Lua response validation logic.

## Structure

- `lua/photon-response-validator.lua` - The main Lua script that validates Photon geocoding responses
- `tests/lua/test-photon-response-validator.lua` - Unit tests for the Lua validation logic
- `tests/run-lua-tests.sh` - Shell script to run the Lua tests

## Running Tests

### Prerequisites

Install Lua 5.3:
```bash
# Ubuntu/Debian
sudo apt-get install lua5.3

# macOS
brew install lua
```

### Running the Tests

From the chart directory:
```bash
# Run tests directly with Lua
lua5.3 tests/lua/test-photon-response-validator.lua

# Or use the test runner script
./tests/run-lua-tests.sh
```

## Test Coverage

The unit tests cover the following scenarios:

1. **Non-200 responses** - Should not add retry headers
2. **Empty response body** - Should mark as retriable with "empty-body"
3. **Empty features array** - Should mark as retriable with "no-results" 
4. **Valid responses with features** - Should not add retry headers
5. **Invalid JSON** - Should mark as retriable with "parse-error"
6. **Non-FeatureCollection responses** - Should mark as retriable with "parse-error"

## Lua Logic

The Lua code validates Photon geocoding responses and adds retry headers when:
- The response body is empty
- The JSON cannot be parsed
- The response is not a FeatureCollection
- The features array is empty

This enables Envoy's retry mechanism to try alternative hosts when a Photon instance returns no geocoding results.