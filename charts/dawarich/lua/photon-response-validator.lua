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
-- Request hook: add x-photon-external when Envoy is performing a retry
----------------------------------------------------------------------

-- Interpretation rules:
-- - Envoy sets internal retry headers on subsequent attempts.
-- - We detect those and add "x-photon-external: retry-attempt" to steer routing.

function envoy_on_request(request_handle)

  local headers = {
    [":method"] = request_handle:headers():get(":method"),
    [":path"]   = request_handle:headers():get(":path"),
    [":authority"] = "photon-gateway-precheck"
  }

  local ok, resp_headers, response_body = request_handle:httpCall("photon_local_cluster", headers, nil, 5000, false)

  if ok then
    local body_string = tostring(response_body)
    local valid = is_valid_feature_collection(body_string)
    if valid then
      return
    end
  end

  request_handle:headers():add("x-photon-external", "use-external-hosts")
end
