# AMS API Gateway

## Overview

`ams-api-gateway` is a project designed to manage and secure APIs through the implementation of **Kong API Gateway**. The project includes custom plugins for  simple rate limits by IP address, authentication, authorization, and dynamic routing of requests on a service and route basis. The entire setup is Dockerized for ease of deployment and scalability.

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
- [Authentication and Context Setter](#authentication-and-context-setter)
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
|   |   ├──auth-rate-limit/
|   |      └──────handler.lua
|   |      └──────schema.lua
|   |   ├──context-setter/
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
    plugins:
      - name: auth-rate-limit
        config:
          limit: 10
          period: 1800

  - name: ams-user-org-service
    url: http://user-org:8000
    routes:
      - name: ams-user-org-route
        paths:
          - /user-org
    plugins:
      - name: context-setter
        config:
          required_permission: "any permissions you want to set"

```

### Plugins
In a microservices architecture, ```handler.lua``` serves as the core of the service logic, defining how requests are processed and responses are generated. It acts as the main entry point for incoming API calls, encapsulating business rules and orchestrating interactions with other services or databases. By maintaining a clear separation of concerns, handler.lua allows developers to implement complex functionalities while ensuring that the codebase remains modular and maintainable.

On the other hand, schema.lua plays a crucial role in defining the data structure and validation rules for the service. It establishes the expected input and output formats, ensuring that data is consistent and adheres to specified criteria. This layer of validation not only enhances data integrity but also simplifies debugging and testing. Together, handler.lua and schema.lua form a robust foundation for building scalable and reliable microservices, facilitating seamless integration and collaboration within a distributed architecture.


## Dockerization
```
services:
  ams-gateway:
    build: .
    image: ams-gateway:latest
    container_name: ams-gateway
    restart: always
    tty: true
    environment:
      KONG_DATABASE: "off"
      KONG_DECLARATIVE_CONFIG: "/config/kong.yaml"
      KONG_PROXY_LISTEN: 0.0.0.0:8000
      KONG_PROXY_LISTEN_SSL: 0.0.0.0:8443
      KONG_ADMIN_LISTEN: 0.0.0.0:8001
      KONG_PLUGINS: "auth-rate-limit,context-setter"
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

## Authentication and Context Setter
The ContextSetter plugin is responsible for validating authorization tokens in a Kong-based microservices architecture. Upon receiving a request, the plugin first checks for the presence of an Authorization header. If the token is missing or invalid, it responds with a 401 Unauthorized status. The plugin then constructs a request to an external authentication service to validate the token, encoding necessary parameters and logging the request URI for debugging purposes.

Once the plugin receives a response from the authentication service, it checks the HTTP status code. If the validation fails (non-200 status), it logs the error and returns an appropriate response to the client. If successful, the plugin decodes the JSON response to extract the user ID and sets it as a header for subsequent requests. This functionality ensures that only authenticated users can access protected resources while passing relevant user context through the microservice chain, enhancing security and facilitating user-specific operations.

## Rate limit implementation
The AuthRateLimit plugin is designed to implement rate limiting for incoming requests in a Kong-based microservices architecture. It tracks the number of requests made by each client IP address, using a simple in-memory store to maintain request counts and timestamps. Upon each incoming request, the plugin retrieves the client's IP and checks how many requests have been made within a defined time period.

If the request count exceeds the specified limit, the plugin responds with a 429 Too Many Requests status, notifying the client that the rate limit has been exceeded and prompting them to try again later. This mechanism not only helps protect the service from abuse and brute-force attacks but also ensures a fair usage policy among users, thereby enhancing the overall stability and reliability of the microservice.

## Conclusion
It's the basic microservice setup for rate limit and how authentication and authorization could be done to a microservice way.

to be continued........
