# dockerd
dockerd__ENABLE ?= $(ENABLE_DOCKER)
dockerd__CMD_PREFIX ?= $(SERVICE_CMD_PREFIX)
dockerd__OS ?= $(DEFAULT_OS)
dockerd__SERVICE ?= docker
dockerd__START_CMD ?= $(dockerd__CMD_PREFIX) start $(dockerd__SERVICE)
dockerd__STOP_CMD ?= $(dockerd__CMD_PREFIX) stop $(dockerd__SERVICE)
dockerd__SUDO_BIN ?= $(SUDO_BIN)
dockerd__SUDO_USER ?= $(SUDO_USER)

# docker
docker__BRIDGE ?= dev-tools
docker__CTX ?= .
docker__DAEMONIZE ?= yes
docker__DRIVER ?= bridge
docker__ERR_IF_BRIDGE_EXISTS = no
docker__RESTART_POLICY ?= no
docker__RM_AFTER_STOP ?= no
docker__SUBNET ?= 192.168.100.0/24
docker__SH ?= /usr/bin/env bash
docker__CHECK_DOCKER = docker ps 1>/dev/null
docker__COMMAND = 
docker__DOCKERFILE = 

# service
docker_service__ENABLE = $(ENABLE_DOCKER)
docker_service__TAGS = docker service image

# app
docker_app__ENABLE = $(ENABLE_DOCKER)
docker_app__TAGS = image docker app

# compose
compose__ENABLE = $(ENABLE_DOCKER)
compose__DAEMONIZE ?= yes
compose__FORCE_RECREATE ?= no
compose__NO_CACHE ?= yes
compose__RM_ALL ?= yes
compose__RM_FORCE ?= yes
compose__RM_ON_UP ?= no
compose__RM_STOP ?= yes
compose__RM_VOLUMES ?= no
compose__TIMEOUT ?= 10

# yaml
yaml__SERVICE = foo
yaml__IMAGE = foo:bar
yaml__CONTAINER = $(yaml__SERVICE)
yaml__BRIDGE = $(docker__BRIDGE)
yaml__RESTART_POLICY = no

# BASE IMAGES
DOCKER_ALPINE_IMAGE = alpine:3.18.3
DOCKER_PG_IMAGE = postgres:12.15-alpine3.18
DOCKER_CLICKHOUSE_IMAGE = clickhouse/clickhouse-server:23.3.11.5-alpine
DOCKER_REDIS_IMAGE = redis:7.2.0-alpine3.18

# DOCKER RUST
DOCKER_RUST_TARGET_ARCH = aarch64-unknown-linux-musl
DOCKER_RUST_VERSION = $(RUST_VERSION)