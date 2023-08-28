ARTEFACTS_DIR = $(abspath .artefacts)
LOCALHOST = localhost
SCHEMAS_DIR = migrations/schemas
FIXTURES_DIR = migrations/fixtures
OUT_DIR = $(TOPDIR)/.output

OS_CODENAME = $(shell lsb_release -cs)

PG_ADMIN_DB = postgres
PG_ADMIN_PASSWORD = postgres
PG_ADMIN = postgres
PG_PORT = 5432
PG_HOST = $(LOCALHOST)
PG_CONFIG = $(shell which pg_config)

REDIS_ADMIN = default
REDIS_ADMIN_DB = 0
REDIS_ADMIN_PASSWORD =
REDIS_PORT = 6379
REDIS_HOST = $(LOCALHOST)
REDIS_CONFIG_REWRITE = yes

LOCALE_LANG = en_US.UTF-8
LOCALE_LC_ALL = en_US.UTF-8
LOCALE_LC_CTYPE = en_US.UTF-8

SH = $(shell which sh)
BASH = $(shell which bash)
SUDO = $(shell which sudo)

PWD = $$(shell pwd)

CPPFLAGS = $(shell echo $${CPPFLAGS})
LDFLAGS = $(shell echo $${LDFLAGS})
CC = $(shell echo $${CC})
CXX = $(shell echo $${CXX})

SERVICE_CMD_PREFIX = brew services
SERVICE_START_CMD = $(SERVICE_CMD_PREFIX) start
SERVICE_STOP_CMD = $(SERVICE_CMD_PREFIX) stop

SERVICE_DB = fizzbuzz
SERVICE_PASSWORD = 12345
SERVICE_USER = foobar

BUILD_VERSION = $(shell git log -1 --format="%h")
DATABASE_URL = postgres://$(SERVICE_USER):$(SERVICE_PASSWORD)@$(PG_HOST):$(PG_PORT)/$(SERVICE_DB)

RUST_VERSION = 1.71.1
RUST_TARGET_ARCH = aarch64-apple-darwin

HOST_APPS = yes
HOST_SERVICES = yes
OTHER_APPS = no
OTHER_SERVICES = no
DOCKER_APPS = no
DOCKER_SERVICES = no

DOCKER_DAEMONIZE = yes
DOCKER_ALPINE_IMAGE = alpine:3.18.3
DOCKER_NETWORK_DRIVER = bridge
DOCKER_NETWORK_NAME = dev-tools
DOCKER_NETWORK_SUBNET = 192.168.100.0/24
DOCKER_PG_IMAGE = postgres:12.15-alpine3.18
DOCKER_REDIS_IMAGE = redis:7.2.0-alpine3.18
DOCKER_RUST_TARGET_ARCH = aarch64-unknown-linux-musl
DOCKER_RUST_VERSION = $(RUST_VERSION)

RUSTFLAGS = -C target-feature=-crt-static

MODE = host

# templates/makefiles/cargo.mk
CARGO_PROFILE = dev
CARGO_CLIPPY_FORMAT = human
CARGO_CLIPPY_REPORT = &1
CARGO_TARGET_DIR = target
CARGO_INSTALL_DIR = /usr/local/bin
CARGO_FEATURES =
CARGO_LINTS =

# templates/makefiles/app.mk
ENVS =
OPTS =
VENV = ''
LOG_FILE = $(ARTEFACTS_DIR)/logs.txt
PID_FILE = $(ARTEFACTS_DIR)/.pid

# templates/makefiles/py.mk + pip.mk + venv.mk
PY_MAJOR = 3.11
PY_MINOR = 4
PY_OWNER = $(USER)
PY_PREFIX = $(shell echo ~/.py/$(PY_MAJOR).$(PY_MINOR))

# python
PYTHON = $(PY_PREFIX)/bin/python$(PY_MAJOR)

# templates/makefiles/compose.mk 
COMPOSE_DAEMONIZE = yes
COMPOSE_FORCE_RECREATE = no
COMPOSE_NO_CACHE = yes
COMPOSE_RM_ALL = no
COMPOSE_RM_FORCE = yes
COMPOSE_RM_ON_UP = no
COMPOSE_RM_STOP = yes
COMPOSE_RM_VOLUMES = no
COMPOSE_TIMEOUT = 10
