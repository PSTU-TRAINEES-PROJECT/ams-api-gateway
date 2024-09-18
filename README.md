# AMS API Gateway

## Overview

`ams-api-gateway` is a project designed to manage and secure APIs through the implementation of **Kong API Gateway**. The project includes custom plugins for token verification and dynamic routing of requests on a service and route basis. The entire setup is Dockerized for ease of deployment and scalability.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Kong Configuration](#kong-configuration)
  - [Service and Route Configuration](#service-and-route-configuration)
  - [Plugins - handler & schema](#plugins)
- [Dockerization](#dockerization)
- [Running the Project](#running-the-project)
- [Conclusion](#conclusion)

## Additional features
- [JWT Authentication](#authentication)
- [Rate Limit](#rate-limit-implementation)

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker
- Docker Compose
- Kong Gateway


- `kong/`: Contains Kong configuration files and custom plugins.
- `docker-compose.yml`: Docker Compose file for setting up Kong, PostgreSQL, and other services.

## Project Structure
```
AMS-USER-MANAGEMENT/
├── kong/
│   ├── config/
|   |   └──konf.yaml
│   ├── plugins/
|   |   ├──gateway/
|   |      └──────handler.lua
|   |      └──────schema.lua
│   ├── docker-compose.yml
|   |───Dockerfile
|   |
│   ├── scripts/
|   |   └──deploy.sh
|   |   └──deploy-up.sh
├── .gitignore
├── README.md
```


## Kong Configuration

### Service and Route Configuration

Kong allows the defining of multiple services and routes to manage API requests efficiently. In this project:

- **Services** represent each microservice in your architecture.
- **Routes** map the incoming requests to the appropriate services.
- **paths** paths represent the URL for this service

Example configuration:

```yaml
_format_version: "3.0"
_transform: true

services:
  - name: ams-auth-service
    url: http://auth:8000
    routes:
      - name: ams-auth-route
        paths:
          - /auth
  - name: ams-appointment-service
    url: http://appointment:8000
    routes:
      - name: ams-appointment-route
        paths:
          - /appointment
```

### Plugins
The provided ```handler.lua``` represent a custom plugin for the Kong API Gateway named "ams-gateway." The plugin is designed to handle bearer token authentication for incoming requests while allowing certain paths, like signup and login, to bypass this authorization check. When a request is received, the plugin first checks if the request path matches any of the defined bypass paths. If so, it logs the action and permits the request to proceed without further checks.
Otherwise, it retrieves the bearer token from the specified header, which defaults to "Authorization." If the token is missing or improperly formatted, the plugin responds with a 401 Unauthorized status, effectively denying access.

Additionally, the plugin includes a configuration ```schema.lua``` that allows administrators to set the required header for token retrieval. This schema ensures that the plugin can be easily integrated into various setups by enabling the specification of the desired header name through the Kong Admin API. 
While the validate_token function is defined, its implementation is currently empty, suggesting that additional logic can be incorporated later for validating the token against an authentication service or database. Overall, the "ams-gateway" plugin provides a streamlined mechanism for token-based authentication, enhancing security for specific API endpoints in the Kong ecosystem.

## Dockerization
```
services:
  ams-gateway:
    build: .
    image: ams-gateway:latest
    container_name: ams-gateway
    environment:
      KONG_DATABASE: "off"
      KONG_DECLARATIVE_CONFIG: "/config/kong.yaml"
      KONG_PROXY_LISTEN: 0.0.0.0:8000
      KONG_PROXY_LISTEN_SSL: 0.0.0.0:8443
      KONG_ADMIN_LISTEN: 0.0.0.0:8001
      KONG_PLUGINS: "ams-gateway"
    networks:
      - ams-network
    ports:
      - "8000:8000"
      - "8001:8001"
      - "8443:8443"
      - "8444:8444"

networks:
  ams-network:
    name: ams-network
    driver: bridge

```

## Running the Project
Ensure all other services are running in the same network. Then run the command
```
docker compose up --build
```

## Authentication
to be continued.........

## Rate limit implementation
to be continued........

## Conclusion
to be continued........
