-- envoy.filters.http.lua before router
local cjson = require("cjson.safe")

function envoy_on_request(h)
  -- Skip if already decided to use public
  if h:headers():get("x-photon-skip-preferred") == "1" then return end

  -- Call preferred aggregate (internal + any trusted)
  local rh, rb = h:httpCall("photon_preferred",
    { [":method"]="GET",
      [":path"]=h:headers():get(":path"),
      [":authority"]=h:headers():get(":authority") },
    nil, 2000)  -- ms timeout; tune as needed

  local ok, j = pcall(cjson.decode, rb or "")
  local features = ok and j and j.features
  if type(features) == "table" and #features > 0 then
    -- Serve result directly
    h:respond(rh, rb)
    return
  end

  -- No result -> route to public
  h:headers():set("x-photon-skip-preferred", "1")
  h:clearRouteCache()
  -- fall through to router
end
