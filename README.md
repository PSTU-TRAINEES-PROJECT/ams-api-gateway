# AMS API Gateway

## Overview

`ams-api-gateway` is a project designed to manage and secure APIs through the implementation of **Kong API Gateway**. The project includes custom plugins for token verification and dynamic routing of requests on a service and route basis. The entire setup is Dockerized for ease of deployment and scalability.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Kong Configuration](#kong-configuration)
  - [Service and Route Configuration](#service-and-route-configuration)
- [Dockerization](#dockerization)
- [Running the Project](#running-the-project)
- [Conclusion](#conclusion)


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

## Conclusion
In the gateway folder, you can add multiple files and customize your routing, adding security.
