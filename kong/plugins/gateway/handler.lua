local AMSGateway = {
 PRIORITY = 1000,
 VERSION = "0.0.1",
}

function AMSGateway:response(conf)
   kong.response.set_header("X-Ams-Gateway-Plugin", "ok")
end

return AMSGateway
