local PLUGIN_NAME = "ams-gateway"

local schema = {
  name = PLUGIN_NAME,
  fields = {
    { config = {
        type = "record",
        fields = {
        },
      },
    },
  },
}

return schema
