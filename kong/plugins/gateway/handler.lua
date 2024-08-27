local AMSGateway = {
  PRIORITY = 1000,
  VERSION = "0.0.1"
}

local string_sub  = string.sub
local string_find = string.find

local BEARER_PATTERN = "%s*[Bb]earer%s+"

local function retrieve_token(header_name)
    local header = kong.request.get_header(header_name)
    if not header then return end

    local index, last  = string_find(header, BEARER_PATTERN)
    if not index then return end

    local token = string_sub(header, last)
    if not token then return end

    return token
end

local function validate_token(token)

end

function AMSGateway:access(config)
    kong.log.inspect(config)

    local service = kong.router.get_service()
    -- configure private/public api
    -- and get rid of it
    if service.name ~= "ams-user" then return end

    local token = retrieve_token(config.header)
    if not token then
        return kong.response.exit(401, "")
    end

    kong.service.request.set_header("X-Gateway-Says", "OK!")
end

function AMSGateway:header_filter(config)
end


return AMSGateway
