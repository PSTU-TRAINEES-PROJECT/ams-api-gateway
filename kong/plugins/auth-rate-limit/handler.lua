local AuthRateLimit = {
    PRIORITY = 1000,
    VERSION = "0.0.1"
}

local request_counts = {}
local request_times = {}

function AuthRateLimit:access(config)
    local client_ip = "1.2.3.4"
    local current_time = os.time()

    -- Initialize the request count and time for this IP if not set
    if not request_counts[client_ip] then
        request_counts[client_ip] = 0
        request_times[client_ip] = current_time
    end

    -- Reset the count if the time period has passed
    if current_time - request_times[client_ip] >= config.period then
        request_counts[client_ip] = 1
        request_times[client_ip] = current_time
    else
        request_counts[client_ip] = request_counts[client_ip] + 1
    end

    -- Check if the limit has been exceeded
    if request_counts[client_ip] > config.limit then
        return kong.response.exit(429, "Rate limit exceeded")
    end

    kong.log.debug("Current count for IP " .. client_ip .. ": " .. request_counts[client_ip])
end

return AuthRateLimit
