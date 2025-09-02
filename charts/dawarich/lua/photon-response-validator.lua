-- Envoy Lua filter for Photon request/response handling
-- - No external modules (works with stock Envoy image)
-- - Request hook: mark retry attempts so routing can switch to Route B
-- - Response hook: validate body heuristically; if invalid-but-200, mark retriable

----------------------------------------------------------------------
-- Helpers: response body handling and simple FeatureCollection checks
----------------------------------------------------------------------

-- Heuristic validation for GeoJSON FeatureCollection with at least one feature.
local function is_valid_feature_collection(body_string)
  if not body_string or #body_string == 0 then
    return false, "empty-body"
  end

  -- Expect: "type": "FeatureCollection"
  if not body_string:find('"type"%s*:%s*"FeatureCollection"') then
    return false, "unexpected-type"
  end

  -- Expect a features array key present
  if not body_string:find('"features"%s*:') then
    return false, "missing-features"
  end

  -- Explicitly reject an empty array: "features": []
  if body_string:find('"features"%s*:%s*%[%s*%]') then
    return false, "no-results"
  end

  return true, nil
end

----------------------------------------------------------------------
-- Request hook: add x-photon-retry when Envoy is performing a retry
----------------------------------------------------------------------

-- Interpretation rules:
-- - Envoy sets internal retry headers on subsequent attempts.
-- - We detect those and add "x-photon-retry: retry-attempt" to steer routing.

function envoy_on_request(request_handle)
  request_headers:remove("x-photon-retry")

  local request_headers = request_handle:headers()

  local retry_attempt_count_value = request_headers:get("x-envoy-attempt-count") 

  if retry_attempt_count_value ~= nil and tonumber(retry_attempt_count_value) >= 2 then
    request_handle:headers():add("x-photon-retry", "retry-attempt")
  end
end

----------------------------------------------------------------------
-- Response hook: if status=200 but body is semantically unusable, mark retriable
----------------------------------------------------------------------

function envoy_on_response(response_handle)

  -- Only validate successful HTTP responses
  if response_handle:headers():get(":status") ~= "200" then
    return
  end

  local body = response_handle:body()

  if not body then
    return
  end

  local body_size = body:length()

  if body_size == 0 then
    return
  end

  local MAX_BYTES_TO_READ = 524288 -- 512 KiB
  if body_size > MAX_BYTES_TO_READ then
    return
  end

  local body_string = tostring(body:getBytes(0, body_size))

  local is_valid, invalid_reason = is_valid_feature_collection(body_string)

  if not is_valid then
    -- Signal to routing/retry policy that this response should be retried
    response_handle:headers():add("x-photon-retry", invalid_reason)
  end
end
