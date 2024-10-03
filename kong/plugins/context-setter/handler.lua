local http = require "resty.http"
local cjson = require "cjson"      -- Use cjson for JSON decoding

local ContextSetter = {
    PRIORITY = 1000,
    VERSION = "0.0.1"
}

local function encode_args(args)
    local encoded = {}
    for key, value in pairs(args) do
        table.insert(encoded, key .. "=" .. ngx.escape_uri(value))
    end
    return table.concat(encoded, "&")
end

function ContextSetter:access(config)

    local token = kong.request.get_header("Authorization")
    if not token then
        return kong.response.exit(401, "Missing or invalid token")
    end
    print(token)

    local query_params = encode_args({ token = token })
    local uri = "http://auth:8000/api/v1/validate_token?" .. query_params

    kong.log.debug("Sending Request URI: " .. uri)
    local httpc = http.new()  -- Initialize the HTTP client
    local res, err = httpc:request_uri(uri, {
        method = "POST"
    })

    if not res then
        kong.log.err("Request failed: ", err)
        return kong.response.exit(500, { message = "Internal server error" })
    end

    -- Handle the response from the auth service
    if res.status ~= 200 then
        kong.log.err("Auth service response: ", res.status, " - ", res.body or "No response body")
        return kong.response.exit(res.status, { message = "Invalid token" })
    end
    kong.log.notice("Response body: ", res.body)

    local status, payload = pcall(cjson.decode, res.body)

    if not status then
        kong.log.err("Failed to decode JSON: ", payload)  -- payload contains the error message
        return kong.response.exit(500, { message = "Invalid JSON response" })
    end

    if payload and payload.id then
        kong.service.request.set_header("X-User-ID", payload.id)
    else
        kong.log.err("Payload is missing 'id'")
        return kong.response.exit(500, { message = "Invalid payload" })
    end
end

return ContextSetter
