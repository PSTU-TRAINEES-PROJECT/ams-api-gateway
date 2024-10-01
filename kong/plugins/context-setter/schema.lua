local typedefs = require "kong.db.schema.typedefs"

return {
    name = "context-setter",
    fields = {
        { consumer = typedefs.no_consumer },
        { protocols = typedefs.protocols_http },
        {
            config = {
                type = "record",
                fields = {
                    { required_permission = { type = "string", required = true } },
                },
            },
        },
    },
}
