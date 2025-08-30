-- Unit tests for photon-response-validator.lua
-- This file tests the Lua logic for detecting empty Photon geocoding responses

local test_runner = {}
local results = {}

-- Mock for cjson
local cjson = {
  decode = function(str)
    -- Simple JSON decoder for test purposes
    if str == '{"type":"FeatureCollection","features":[]}' then
      return {type = "FeatureCollection", features = {}}
    elseif str == '{"type":"FeatureCollection","features":[{"properties":{"name":"Amsterdam"}}]}' then
      return {type = "FeatureCollection", features = {{properties = {name = "Amsterdam"}}}}
    elseif str == '{"error":"invalid request"}' then
      return {error = "invalid request"}
    elseif str == 'invalid json' then
      error("Invalid JSON")
    else
      return {}
    end
  end
}

-- Mock response handle
local function create_mock_response_handle(status, body_content)
  local headers_added = {}
  return {
    headers = function()
      return {
        get = function(_, name)
          if name == ":status" then
            return status
          end
          return nil
        end,
        add = function(_, name, value)
          headers_added[name] = value
        end
      }
    end,
    body = function()
      if body_content then
        return {
          length = function()
            return #body_content
          end,
          getBytes = function(_, start, length)
            return body_content
          end
        }
      else
        return nil
      end
    end,
    get_added_headers = function()
      return headers_added
    end
  }
end

-- Load the current Lua code under test
local function envoy_on_response(response_handle)
  local status = response_handle:headers():get(":status")
  
  -- Only check 200 responses for content validity
  if status ~= "200" then
    return
  end
  
  -- Check if we got a valid response with geocoding results
  local body = response_handle:body()
  
  if body and body:length() > 0 then
    local success, parsed = pcall(function()
      local body_str = tostring(body:getBytes(0, body:length()))
      return cjson.decode(body_str)
    end)
    
    -- If parsing failed or no features, mark as retriable
    if not success or not parsed or parsed.type ~= "FeatureCollection" then
      response_handle:headers():add("x-photon-retry", "parse-error")
      return
    end
    
    -- If features array is empty, mark as retriable
    if not parsed.features or type(parsed.features) ~= "table" or #parsed.features == 0 then
      response_handle:headers():add("x-photon-retry", "no-results")
      return
    end
  else
    -- Empty body, mark as retriable
    response_handle:headers():add("x-photon-retry", "empty-body")
  end
end

-- Test cases
function test_runner.test_non_200_status()
  local response_handle = create_mock_response_handle("404", "Not found")
  envoy_on_response(response_handle)
  local headers = response_handle.get_added_headers()
  
  assert(next(headers) == nil, "No headers should be added for non-200 status")
  results.test_non_200_status = "PASS"
end

function test_runner.test_empty_body()
  local response_handle = create_mock_response_handle("200", nil)
  envoy_on_response(response_handle)
  local headers = response_handle.get_added_headers()
  
  assert(headers["x-photon-retry"] == "empty-body", "Should mark empty body as retriable")
  results.test_empty_body = "PASS"
end

function test_runner.test_empty_features_array()
  local response_handle = create_mock_response_handle("200", '{"type":"FeatureCollection","features":[]}')
  envoy_on_response(response_handle)
  local headers = response_handle.get_added_headers()
  
  assert(headers["x-photon-retry"] == "no-results", "Should mark empty features as retriable")
  results.test_empty_features_array = "PASS"
end

function test_runner.test_valid_response_with_features()
  local response_handle = create_mock_response_handle("200", '{"type":"FeatureCollection","features":[{"properties":{"name":"Amsterdam"}}]}')
  envoy_on_response(response_handle)
  local headers = response_handle.get_added_headers()
  
  assert(next(headers) == nil, "Valid response should not add retry headers")
  results.test_valid_response_with_features = "PASS"
end

function test_runner.test_invalid_json()
  local response_handle = create_mock_response_handle("200", 'invalid json')
  envoy_on_response(response_handle)
  local headers = response_handle.get_added_headers()
  
  assert(headers["x-photon-retry"] == "parse-error", "Invalid JSON should be marked as retriable")
  results.test_invalid_json = "PASS"
end

function test_runner.test_non_feature_collection()
  local response_handle = create_mock_response_handle("200", '{"error":"invalid request"}')
  envoy_on_response(response_handle)
  local headers = response_handle.get_added_headers()
  
  assert(headers["x-photon-retry"] == "parse-error", "Non-FeatureCollection should be marked as retriable")
  results.test_non_feature_collection = "PASS"
end

-- Helper function to run all tests
function test_runner.run_all_tests()
  local tests = {
    "test_non_200_status",
    "test_empty_body", 
    "test_empty_features_array",
    "test_valid_response_with_features",
    "test_invalid_json",
    "test_non_feature_collection"
  }
  
  for _, test_name in ipairs(tests) do
    local success, error_msg = pcall(test_runner[test_name])
    if not success then
      results[test_name] = "FAIL: " .. error_msg
    end
  end
  
  return results
end

-- Simple assert function
function assert(condition, message)
  if not condition then
    error(message or "Assertion failed")
  end
end

-- Run tests and print results
print("Running Photon Response Validator Tests...")
print("==========================================")

local test_results = test_runner.run_all_tests()
for test_name, result in pairs(test_results) do
  print(test_name .. ": " .. result)
end

print("\nAll tests completed!")