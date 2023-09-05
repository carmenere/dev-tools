DOCKERFILES = $(DEVTOOLS_DIR)/dockerfiles
TMPL_DIR = $(DEVTOOLS_DIR)/templates
MK = $(TMPL_DIR)/make
DOCKER_COMPOSE = $(TMPL_DIR)/compose

include $(DEVTOOLS_DIR)/lib.mk

########################################################################################################################
# VARS
########################################################################################################################
OUTDIR = $(shell pwd)/.output
INSTALL_DIR = /usr/local/bin
PROJECT_ROOT = $(shell pwd)

#
ENABLE_HOST_APPS = no
ENABLE_DOCKER_APPS = no
ENABLE_HOST_SERVICES = no
ENABLE_DOCKER_SERVICES = no
ENABLE_VENVS = no
ENABLE_TESTS = no
ENABLE_CARGO = no
ENABLE_SCHEMAS = no
ENABLE_FIXTURES = no
ENABLE_UPGRADE = no
ENABLE_REPORTS = no
ENABLE_DEPS = no
ENABLE_INIT = no
ENABLE_TMUX = no

# DOCKER
DOCKER_ALPINE_IMAGE = alpine:3.18.3
DOCKER_DAEMONIZE = yes
DOCKER_NETWORK_DRIVER = bridge
DOCKER_NETWORK_NAME = dev-tools
DOCKER_NETWORK_SUBNET = 192.168.100.0/24
DOCKER_PG_IMAGE = postgres:12.15-alpine3.18
DOCKER_CLICKHOUSE_IMAGE = clickhouse/clickhouse-server:23.3.11.5-alpine
DOCKER_REDIS_IMAGE = redis:7.2.0-alpine3.18
DOCKER_RUST_TARGET_ARCH = aarch64-unknown-linux-musl
DOCKER_RUST_VERSION = $(RUST_VERSION)

# ERROR
EXIT_IF_CREATE_EXISTED_DB = no
EXIT_IF_CREATE_EXISTED_USER = no

# HOST
LOCALHOST = localhost

# LOCAL
LOCALE_LANG = en_US.UTF-8
LOCALE_LC_ALL = en_US.UTF-8
LOCALE_LC_CTYPE = en_US.UTF-8

#
OS = ubuntu

ifeq ($(OS),ubuntu)
OS_CODENAME = $(shell lsb_release -cs)
else ifeq ($(OS),alpine)
OS_CODENAME = $(shell cat /etc/os-release)
else
OS_CODENAME = unknown
endif


# 
FIXTURES_DIR = migrations/fixtures
SCHEMAS_DIR = migrations/schemas

# CLICKHOUSE
CH_ADMIN = admin
CH_ADMIN_DB = default
CH_ADMIN_PASSWORD = 12345
CH_HOST = $(LOCALHOST)
CH_PORT = 9000
CH_USER_XML = /opt/homebrew/etc/clickhouse-server/users.d/$(CH_ADMIN).xml

# POSTGRESQ
PG_ADMIN = postgres
PG_ADMIN_DB = postgres
PG_ADMIN_PASSWORD = postgres
PG_CONFIG = $(shell which pg_config)
PG_HOST = $(LOCALHOST)
PG_PORT = 5432
PG_DATABASE_URL = postgres://$(SERVICE_USER):$(SERVICE_PASSWORD)@$(PG_HOST):$(PG_PORT)/$(SERVICE_DB)

# REDI
REDIS_ADMIN = default
REDIS_ADMIN_DB = 0
REDIS_ADMIN_PASSWORD = 
REDIS_HOST = $(LOCALHOST)
REDIS_PORT = 6379

# RUS
RUST_TARGET_ARCH = aarch64-apple-darwin
RUST_VERSION = 1.71.1
RUSTFLAGS = -C target-feature=-crt-static

# OS service
SERVICE_CMD_PREFIX = brew services
SERVICE_START_CMD = $(SERVICE_CMD_PREFIX) start
SERVICE_STOP_CMD = $(SERVICE_CMD_PREFIX) stop

# OS services credential
SERVICE_DB = fizzbuzz
SERVICE_PASSWORD = 12345
SERVICE_USER = foobar

# C & C++ flags
CC := $(shell echo ${CC})
CPPFLAGS := $(shell echo ${CPPFLAGS})
CXX := $(shell echo ${CXX})
LDFLAGS := $(shell echo ${LDFLAGS})

# Common shell command
BASH = $(shell which bash)
BUILD_VERSION = $(shell git log -1 --format="%h")
PWD = $(shell pwd)
SH = $(shell which sh)

# sud
SUDO_BIN = $(shell which sudo)
SUDO_USER = 

# toolchain's python
PY_MAJOR = 3.11
PY_MINOR = 4
PY_OWNER = $(USER)
PYTHON = $(shell which python3)
TPYTHON = $(PYTHON)
PY_DIR = $(dir $(PYTHON))

# cargo
CARGO_TARGET_DIR = target
CARGO_PROFILE = dev

########################################################################################################################
# Register defaults
########################################################################################################################
DEFAULTS += BASH
DEFAULTS += BUILD_VERSION
DEFAULTS += CARGO_PROFILE
DEFAULTS += CARGO_TARGET_DIR
DEFAULTS += CC
DEFAULTS += CH_ADMIN
DEFAULTS += CH_ADMIN_DB
DEFAULTS += CH_ADMIN_PASSWORD
DEFAULTS += CH_HOST
DEFAULTS += CH_PORT
DEFAULTS += CH_USER_XML
DEFAULTS += CPPFLAGS
DEFAULTS += CXX
DEFAULTS += DOCKER_ALPINE_IMAGE
DEFAULTS += DOCKER_CLICKHOUSE_IMAGE
DEFAULTS += DOCKER_DAEMONIZE
DEFAULTS += DOCKER_NETWORK_DRIVER
DEFAULTS += DOCKER_NETWORK_NAME
DEFAULTS += DOCKER_NETWORK_SUBNET
DEFAULTS += DOCKER_PG_IMAGE
DEFAULTS += DOCKER_REDIS_IMAGE
DEFAULTS += DOCKER_RUST_TARGET_ARCH
DEFAULTS += DOCKER_RUST_VERSION
DEFAULTS += EXIT_IF_CREATE_EXISTED_DB
DEFAULTS += EXIT_IF_CREATE_EXISTED_USER
DEFAULTS += FIXTURES_DIR
DEFAULTS += INSTALL_DIR
DEFAULTS += LDFLAGS
DEFAULTS += LOCALE_LANG
DEFAULTS += LOCALE_LC_ALL
DEFAULTS += LOCALE_LC_CTYPE
DEFAULTS += LOCALHOST
DEFAULTS += OS
DEFAULTS += OS_CODENAME
DEFAULTS += OUTDIR
DEFAULTS += PG_ADMIN
DEFAULTS += PG_ADMIN_DB
DEFAULTS += PG_ADMIN_PASSWORD
DEFAULTS += PG_CONFIG
DEFAULTS += PG_DATABASE_URL
DEFAULTS += PG_HOST
DEFAULTS += PG_PORT
DEFAULTS += PROJECT_ROOT
DEFAULTS += PWD
DEFAULTS += PY_DIR
DEFAULTS += PY_MAJOR
DEFAULTS += PY_MINOR
DEFAULTS += PY_OWNER
DEFAULTS += PYTHON
DEFAULTS += REDIS_ADMIN
DEFAULTS += REDIS_ADMIN_DB
DEFAULTS += REDIS_ADMIN_PASSWORD
DEFAULTS += REDIS_HOST
DEFAULTS += REDIS_PORT
DEFAULTS += RUST_TARGET_ARCH
DEFAULTS += RUST_VERSION
DEFAULTS += RUSTFLAGS
DEFAULTS += SCHEMAS_DIR
DEFAULTS += SERVICE_CMD_PREFIX
DEFAULTS += SERVICE_DB
DEFAULTS += SERVICE_PASSWORD
DEFAULTS += SERVICE_START_CMD
DEFAULTS += SERVICE_STOP_CMD
DEFAULTS += SERVICE_USER
DEFAULTS += SH
DEFAULTS += SUDO_BIN
DEFAULTS += SUDO_USER
DEFAULTS += TPYTHON

########################################################################################################################
# Order matters!
########################################################################################################################
include $(DEVTOOLS_DIR)/toolchain/defaults.mk

include $(DEVTOOLS_DIR)/ctxes/app.mk
include $(DEVTOOLS_DIR)/ctxes/cargo.mk
include $(DEVTOOLS_DIR)/ctxes/cli.mk
include $(DEVTOOLS_DIR)/ctxes/pip.mk
include $(DEVTOOLS_DIR)/ctxes/pytest.mk
include $(DEVTOOLS_DIR)/ctxes/python.mk
include $(DEVTOOLS_DIR)/ctxes/rustup.mk
include $(DEVTOOLS_DIR)/ctxes/services.mk
include $(DEVTOOLS_DIR)/ctxes/tmux.mk
include $(DEVTOOLS_DIR)/ctxes/venv.mk

include $(DEVTOOLS_DIR)/ctxes/docker-apps.mk
include $(DEVTOOLS_DIR)/ctxes/docker-services.mk

include $(DEVTOOLS_DIR)/ctxes/compose.mk
########################################################################################################################

# Render
RENDER = $(TPYTHON) -m render.main