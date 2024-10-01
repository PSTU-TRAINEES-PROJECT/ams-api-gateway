local ContextSetter = {
    PRIORITY = 1000,
    VERSION = "0.0.1"
}

local http = require "resty.http"

function ContextSetter:access(config)
    local token = kong.request.get_header("Authorization")
    if not token or not token:find("Bearer ") then
        return kong.response.exit(401, "Missing or invalid token")
    end

    local bearer_token = token:sub(8)  -- Remove "Bearer " prefix
    local httpc = http.new()

    local res, err = httpc:request_uri("http://auth:8000/", {
        method = "POST",
        body = '{"token":"' .. bearer_token .. '"}',
        headers = {
            ["Content-Type"] = "application/json",
        },
    })

    if not res then
        kong.log.err("Failed to request auth service: ", err)
        return kong.response.exit(500, "Internal Server Error")
    end

    if res.status ~= 200 then
        return kong.response.exit(res.status, res.body)
    end

    local payload = kong.json.decode(res.body)
    kong.request.set_header("X-User-ID", payload.user_id)
    kong.request.set_header("X-Permissions", payload.permissions)

    kong.log.debug("User ID: " .. payload.user_id .. ", Permissions: " .. payload.permissions)
end

return ContextSetter
