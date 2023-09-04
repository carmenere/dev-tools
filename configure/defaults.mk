DOCKERFILES = $(DEVTOOLS_DIR)/dockerfiles
TMPL_DIR = $(DEVTOOLS_DIR)/templates
MK = $(TMPL_DIR)/make
DOCKER_COMPOSE = $(TMPL_DIR)/compose

########################################################################################################################
# Functions
########################################################################################################################
include $(DEVTOOLS_DIR)/lib.mk

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
# $1:profile,$2:TARGET_DIR,$3:TARGET_ARCH
# EXAMPLE = $(call cargo_bins,dev,target,aarch64-apple-darwin)
define cargo_bins
$(eval 
ifeq ($1,dev)
x__PROFILE_DIR = debug
else
x__PROFILE_DIR = $1
endif)$2/$3/$(x__PROFILE_DIR)
endef

# $1:image_name,$2:tag
# EXAMPLE = $(call docker_image,ABC,latest)
# EXAMPLE = $(call docker_image,ABC)
define docker_image
$(eval 
ifneq ($2,)
x__IMAGE = $1:$2
else
x__IMAGE = $1
endif)$(x__IMAGE)
endef

# $1:prefix
# EXAMPLE = $(call list_by_prefix,pg_x__env_)
define list_by_prefix
$(foreach V,$(filter $1%,$(.VARIABLES)),$(subst $1,,$(V)))
endef

# $1:src,$2:dst
# EXAMPLE = $(call copy_ctx,pg_X__env_,pg_Y__env_)
define copy_ctx
$(foreach V,$(filter $1%,$(.VARIABLES)), \
    $(eval $2$(subst $1,,$(V)) = $($(V))) \
)
endef

# $1:src,$2:vars,$3:dst
# EXAMPLE = $(call inherit,pg_X__env,ABC QWERTY,pg_Y__env_)
define inherit_vars
$(foreach V,$2,$(eval $3$(V) ?= $$($1$(V))))
endef

# $1:src,$2:dst
# EXAMPLE = $(call inherit_ctx,pg_X__env_,pg_Y__env_)
define inherit_ctx
$(foreach V,$(filter $1%,$(.VARIABLES)), \
    $(eval $2$(subst $1,,$(V)) ?= $$($(V))) \
)
endef

########################################################################################################################

d__IN = $(MK)/common/defaults.jinja2
d__OUT = $(MK)/common/defaults.j2

d__OUTDIR = $(shell pwd)/.output
d__SELFDIR = $$(realpath $$(dir $$(lastword $$(MAKEFILE_LIST))))
d__INSTALL_DIR = /usr/local/bin
d__PROJECT_ROOT = $(shell pwd)

#
d__APPS_ENABLED = no
d__SERVICES_ENABLED = no

# DOCKER
d__DOCKER_ALPINE_IMAGE = alpine:3.18.3
d__DOCKER_DAEMONIZE = yes
d__DOCKER_NETWORK_DRIVER = bridge
d__DOCKER_NETWORK_NAME = dev-tools
d__DOCKER_NETWORK_SUBNET = 192.168.100.0/24
d__DOCKER_PG_IMAGE = postgres:12.15-alpine3.18
d__DOCKER_CLICKHOUSE_IMAGE = clickhouse/clickhouse-server:23.3.11.5-alpine
d__DOCKER_REDIS_IMAGE = redis:7.2.0-alpine3.18
d__DOCKER_RUST_TARGET_ARCH = aarch64-unknown-linux-musl
d__DOCKER_RUST_VERSION = $(d__RUST_VERSION)

# ERROR
d__EXIT_IF_CREATE_EXISTED_DB = no
d__EXIT_IF_CREATE_EXISTED_USER = no

# HOST
d__LOCALHOST = localhost

# LOCAL
d__LOCALE_LANG = en_US.UTF-8
d__LOCALE_LC_ALL = en_US.UTF-8
d__LOCALE_LC_CTYPE = en_US.UTF-8

#
d__MODE = host
d__OS = ubuntu

# 
d__FIXTURES_DIR = migrations/fixtures
d__SCHEMAS_DIR = migrations/schemas

# CLICKHOUSE
d__CH_ADMIN = admin
d__CH_ADMIN_DB = default
d__CH_ADMIN_PASSWORD = 12345
d__CH_HOST = $(d__LOCALHOST)
d__CH_PORT = 9000
d__CH_USER_XML ?= /opt/homebrew/etc/clickhouse-server/users.d/$(d__CH_ADMIN).xml

# POSTGRESQ
d__PG_ADMIN = postgres
d__PG_ADMIN_DB = postgres
d__PG_ADMIN_PASSWORD = postgres
d__PG_CONFIG = $(shell which pg_config)
d__PG_HOST = $(d__LOCALHOST)
d__PG_PORT = 5432
d__PG_DATABASE_URL = postgres://$(d__SERVICE_USER):$(d__SERVICE_PASSWORD)@$(d__PG_HOST):$(d__PG_PORT)/$(d__SERVICE_DB)

# REDI
d__REDIS_ADMIN = default
d__REDIS_ADMIN_DB = 0
d__REDIS_ADMIN_PASSWORD = 
d__REDIS_HOST = $(d__LOCALHOST)
d__REDIS_PORT = 6379

# RUS
d__RUST_TARGET_ARCH = aarch64-apple-darwin
d__RUST_VERSION = 1.71.1
d__RUSTFLAGS = -C target-feature=-crt-static

# OS service
d__SERVICE_CMD_PREFIX = brew services
d__SERVICE_START_CMD = $(d__SERVICE_CMD_PREFIX) start
d__SERVICE_STOP_CMD = $(d__SERVICE_CMD_PREFIX) stop

# OS services credential
d__SERVICE_DB = fizzbuzz
d__SERVICE_PASSWORD = 12345
d__SERVICE_USER = foobar

# Common shell command
d__BASH = $(shell which bash)
d__BUILD_VERSION = $(shell git log -1 --format="%h")
d__CC = $(shell echo $${CC})
d__CPPFLAGS = $(shell echo $${CPPFLAGS})
d__CXX = $(shell echo $${CXX})
d__LDFLAGS = $(shell echo $${LDFLAGS})
d__OS_CODENAME = $(shell lsb_release -cs)
d__PWD = $(shell pwd)
d__SH = $(shell which sh)

# sud
d__SUDO_BIN = $(shell which sudo)
d__SUDO_USER = 

# toolchain's python
d__PY_MAJOR = 3.11
d__PY_MINOR = 4
d__PY_OWNER = $(USER)
d__PYTHON = $(shell which python3)
d__TPYTHON = $(d__PYTHON)
d__PY_DIR = $(dir $(d__PYTHON))

# cargo
d__CARGO_TARGET_DIR = target
d__CARGO_PROFILE = dev


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
RENDER ?= $(d__TPYTHON) -m render.main