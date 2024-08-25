FROM kong/kong:3.2.2-alpine as base

USER root

RUN apk update && apk add g++ libsodium-dev git unzip luarocks
RUN luarocks install paseto

FROM base

COPY config/kong.yaml /config/kong.yaml

USER root

# gateway
RUN mkdir /usr/local/share/lua/5.1/kong/plugins/ams-gateway
COPY plugins/gateway/. /usr/local/share/lua/5.1/kong/plugins/ams-gateway

USER kong
