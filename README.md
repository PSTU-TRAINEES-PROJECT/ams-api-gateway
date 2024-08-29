# AMS API Gateway

## Overview

`ams-api-gateway` is a project designed to manage and secure APIs through the implementation of **Kong API Gateway**. The project includes custom plugins for token verification and dynamic routing of requests on a service and route basis. The entire setup is Dockerized for ease of deployment and scalability.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Kong Configuration](#kong-configuration)
  - [Custom Plugins](#custom-plugins)
    - [Token Verification Plugin](#token-verification-plugin)
    - [Dynamic Routing Plugin](#dynamic-routing-plugin)
  - [Service and Route Configuration](#service-and-route-configuration)
- [Dockerization](#dockerization)
  - [Docker Compose Setup](#docker-compose-setup)
- [Running the Project](#running-the-project)
- [Conclusion](#conclusion)

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker
- Docker Compose
- Kong Gateway


- `kong/`: Contains Kong configuration files and custom plugins.
- `docker-compose.yml`: Docker Compose file for setting up Kong, PostgreSQL, and other services.

## Kong Configuration

### Custom Plugins

Two custom plugins have been added to enhance the functionality of the Kong API Gateway:

#### Token Verification Plugin

This plugin ensures that all incoming requests are authenticated using a valid token. It checks the presence of the token in the request header and validates it against the configured rules.

- **Functionality:**
  - Extracts the token from the `Authorization` header.
  - Validates the token against predefined criteria.
  - Rejects the request if the token is invalid or missing.

#### Dynamic Routing Plugin

The dynamic routing plugin is responsible for directing incoming requests to the appropriate service or route based on custom logic.

- **Functionality:**
  - Analyzes the incoming request to determine the target service or route.
  - Dynamically redirects the request to the specified endpoint.
  - Supports service and route-wise request handling.

### Service and Route Configuration

Kong allows defining multiple services and routes to manage API requests efficiently. In this project:

- **Services** represent each microservice in your architecture.
- **Routes** map the incoming requests to the appropriate services.

Example configuration:

```yaml
services:
  - name: user-service
    url: http://user-service:7001
    routes:
      - name: user-route
        paths: ["/user"]

  - name: schedule-service
    url: http://schedule-service:7002
    routes:
      - name: schedule-route
        paths: ["/schedule"]

