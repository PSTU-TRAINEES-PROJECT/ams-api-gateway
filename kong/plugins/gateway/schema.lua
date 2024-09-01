
local typedefs = require "kong.db.schema.typedefs"

return {
  name = "ams-gateway",
  fields = {
    { consumer = typedefs.no_consumer },
    { protocols = typedefs.protocols_http },
    {
      config = {
        type = "record",
        fields = {
            {  header = { type = "string", required = true, default  = "Authorization" }, },
        },
      },
    },
  },
}