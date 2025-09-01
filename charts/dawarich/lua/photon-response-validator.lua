-- Envoy Lua filter for Photon request/response handling
-- - No external modules (works with stock Envoy image)
-- - Request hook: mark retry attempts so routing can switch to Route B
-- - Response hook: validate body heuristically; if invalid-but-200, mark retriable

----------------------------------------------------------------------
-- Helpers: response body handling and simple FeatureCollection checks
----------------------------------------------------------------------

-- Read the full response body as a Lua string with a size guard.
local function read_response_body(response_handle)
  local body = response_handle:body()
  if not body then 
    return nil 
  end

  local body_length = body:length()
  if not body_length or body_length == 0 then 
    return nil 
  end

  -- Safety cap to avoid large allocations on unexpected payloads.
  local MAX_BYTES_TO_READ = 524288 -- 512 KiB
  if body_length > MAX_BYTES_TO_READ then
    return nil
  end

  return tostring(body:getBytes(0, body_length))
end

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
-- - If caller already provided x-photon-retry, we do not overwrite it.

function envoy_on_request(request_handle)
  local request_headers = request_handle:headers()

  -- Internal Envoy retry signals we look for:
  -- x-envoy-retry-on           -> HTTP retry conditions active
  -- x-envoy-upstream-rq-retry-count -> present on retry attempts, value is attempt count (0-based)
  local retry_signal_http         = request_headers:get("x-envoy-retry-on")
  local retry_attempt_count_value = request_headers:get("x-envoy-upstream-rq-retry-count")

  -- Also consider downstream-provided explicit hint (rare, but be permissive)
  local downstream_retry_hint     = request_headers:get("x-photon-retry")

  local envoy_is_retrying = (retry_signal_http ~= nil) or (retry_attempt_count_value ~= nil)

  -- Add our routing hint only when Envoy is retrying and caller didn’t set one.
  if envoy_is_retrying and not downstream_retry_hint then
    request_headers:add("x-photon-retry", "retry-attempt")
  end
end

----------------------------------------------------------------------
-- Response hook: if status=200 but body is semantically unusable, mark retriable
----------------------------------------------------------------------

function envoy_on_response(response_handle)
  local response_headers = response_handle:headers()
  local http_status      = response_headers:get(":status")

  -- Only validate successful HTTP responses
  if http_status ~= "200" then
    return
  end

  local response_body_string = read_response_body(response_handle)
  local is_valid, invalid_reason = is_valid_feature_collection(response_body_string)

  if not is_valid then
    -- Signal to routing/retry policy that this response should be retried
    response_headers:add("x-photon-retry", invalid_reason)
  end
end
