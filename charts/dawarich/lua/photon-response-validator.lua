-- Envoy Lua filter for Photon request/response handling
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
-- - We check that the request is a retry attempt, if so we set the x-photon-external header
-- - Otherwise we remove any existing x-photon-external header
-- - We check the internal host, if it has a record we continue to the internal route
-- - Otherwise we set the x-photon-external header in order to route to the external route


function envoy_on_request(request_handle)

  local headers = request_handle:headers()
  if headers:get(":path") == "/healthz" then return end
  if tonumber(headers:get("x-envoy-attempt-count") or '1') > 1 then
    headers:add("x-photon-external", "use-external-hosts")
    return
  end

  request_handle:headers():remove("x-photon-external")

  local internal_request_headers = {
    [":method"] = request_handle:headers():get(":method"),
    [":path"]   = request_handle:headers():get(":path"),
    [":authority"] = "photon-gateway-precheck"
  }

  local ok, resp_headers, response_body = request_handle:httpCall("photon_internal", internal_request_headers, nil, 5000, false)

  if ok then
    local body_string = tostring(response_body)
    local valid = is_valid_feature_collection(body_string)
    if valid then
      return
    end
  end

  request_handle:headers():add("x-photon-external", "use-external-hosts")
end
