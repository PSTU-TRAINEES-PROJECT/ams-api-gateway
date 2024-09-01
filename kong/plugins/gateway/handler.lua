local ATSGateway = {
    PRIORITY = 1000,
    VERSION = "0.0.1"
}

local string_sub = string.sub
local string_find = string.find

local BEARER_PATTERN = "%s*[Bb]earer%s+"
local BYPASS_PATHS = { "/auth/api/v1/signup", "/auth/api/v1//login" } -- List of paths to bypass authorization

local function is_bypass_path(path)
    for _, bypass_path in ipairs(BYPASS_PATHS) do
        if path == bypass_path then
            return true
        end
    end
    return false
end

local function retrieve_token(header_name)
    local header = kong.request.get_header(header_name)
    if not header then
        return
    end

    local index, last = string_find(header, BEARER_PATTERN)
    if not index then
        return
    end

    local token = string_sub(header, last)
    if not token then
        return
    end

    return token
end

local function validate_token(token)

end

function ATSGateway:access(config)
    kong.log.inspect(config)
    local request_path = kong.request.get_path()

    if is_bypass_path(request_path) then
        kong.log.debug("Bypassing authorization for path: " .. request_path)
        return
    end

    local token = retrieve_token(config.header)
    if not token then
        return kong.response.exit(401, "")
    end

    kong.service.request.set_header("X-Gateway-Says", "OK!")
end

return ATSGateway
