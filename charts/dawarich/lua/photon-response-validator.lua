local cjson = require "cjson"

function envoy_on_request(request_handle)
  -- If this is a retry (based on the presence of certain Envoy retry headers),
  -- add the x-photon-retry header to route to Route B
  local envoy_retry_grpc = request_handle:headers():get("x-envoy-retry-grpc-on")
  local envoy_retry_on = request_handle:headers():get("x-envoy-retry-on")
  local envoy_upstream_retries = request_handle:headers():get("x-envoy-upstream-rq-retry-count")
  
  if envoy_retry_grpc or envoy_retry_on or envoy_upstream_retries then
    -- This is a retry attempt, route to Route B (all hosts)
    if not request_handle:headers():get("x-photon-retry") then
      request_handle:headers():add("x-photon-retry", "retry-attempt")
    end
  end
end

function envoy_on_response(response_handle)
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