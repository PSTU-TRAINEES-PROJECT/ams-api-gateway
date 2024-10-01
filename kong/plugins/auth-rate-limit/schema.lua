local typedefs = require "kong.db.schema.typedefs"

return {
    name = "auth-rate-limit",
    fields = {
        { consumer = typedefs.no_consumer },
        { protocols = typedefs.protocols_http },
        {
            config = {
                type = "record",
                fields = {
                    { limit = { type = "number", required = true, default = 100 } },
                    { period = { type = "number", required = true, default = 3600 } },  -- in seconds
                },
            },
        },
    },
}
