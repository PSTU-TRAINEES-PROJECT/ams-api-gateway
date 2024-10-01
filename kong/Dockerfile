FROM kong/kong:3.2.2-alpine as base

USER root

RUN apk update && apk add --no-cache g++ libsodium-dev git unzip luarocks \
    && luarocks install paseto

COPY config/kong.yaml /config/kong.yaml

RUN mkdir -p /usr/local/share/lua/5.1/kong/plugins/auth-rate-limit
RUN mkdir -p /usr/local/share/lua/5.1/kong/plugins/context-setter

COPY plugins/auth-rate-limit/. /usr/local/share/lua/5.1/kong/plugins/auth-rate-limit
COPY plugins/context-setter/. /usr/local/share/lua/5.1/kong/plugins/context-setter

USER kong