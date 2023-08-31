DOCKERFILES = $(DEVTOOLS_DIR)/dockerfiles
TMPL_DIR = $(DEVTOOLS_DIR)/templates
MK = $(TMPL_DIR)/make
DOCKER_COMPOSE = $(TMPL_DIR)/compose

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
# $1:profile,$2:TARGET_DIR,$3:TARGET_ARCH
# EXAMPLE = $(call cargo_bins,dev,target,aarch64-apple-darwin)
define cargo_bins
$(eval 
ifeq ($1,dev)
PROFILE_DIR = debug
else
PROFILE_DIR = $1
endif)$2/$3/$(PROFILE_DIR)
endef

# $1:image_name,$2:tag
# EXAMPLE = $(call docker_image,ABC,latest)
# EXAMPLE = $(call docker_image,ABC)
define docker_image
$(eval 
ifneq ($2,)
IMAGE = $1:$2
else
IMAGE = $1
endif)$(IMAGE)
endef

# $1:prefix
# EXAMPLE = $(call list_by_prefix,pg_x__env_)
define list_by_prefix
$(foreach V,$(filter $1%,$(.VARIABLES)),$(subst $1,,$(V)))
endef

# $1:src,$2:dst
# EXAMPLE = $(call copy,pg_X__env_,pg_Y__env_)
define copy
$(foreach V,$(filter $1%,$(.VARIABLES)), \
    $(eval $2$(subst $1,,$(V)) = $($(V))) \
)
endef

# To be cut further
PREFIXES += env
PREFIXES += arg

########################################################################################################################
CTX := d
########################################################################################################################
d__IN = $(MK)/common/defaults.jinja2
d__OUT = $(MK)/common/defaults.j2

d__OUTDIR = $(shell pwd)/.output
d__SELFDIR = $$(realpath $$(dir $$(lastword $$(MAKEFILE_LIST))))
d__INSTALL_DIR = /usr/local/bin
d__PROJECT_ROOT = $(shell pwd)

# DOCKE
d__DOCKER_ALPINE_IMAGE = alpine:3.18.3
d__DOCKER_APPS_ENABLED = no
d__DOCKER_DAEMONIZE = yes
d__DOCKER_NETWORK_DRIVER = bridge
d__DOCKER_NETWORK_NAME = dev-tools
d__DOCKER_NETWORK_SUBNET = 192.168.100.0/24
d__DOCKER_PG_IMAGE = postgres:12.15-alpine3.18
d__DOCKER_REDIS_IMAGE = redis:7.2.0-alpine3.18
d__DOCKER_RUST_TARGET_ARCH = aarch64-unknown-linux-musl
d__DOCKER_RUST_VERSION = $(d__RUST_VERSION)
d__DOCKER_SERVICES_ENABLED = no

# ERROR
d__EXIT_IF_CREATE_EXISTED_DB = no
d__EXIT_IF_CREATE_EXISTED_USER = no

# HOS
d__HOST_APPS_ENABLED = yes
d__HOST_SERVICES_ENABLED = yes
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
include $(DEVTOOLS_DIR)/toolchain/python/defaults.mk

# cargo
d__CARGO_TARGET_DIR = target
d__CARGO_PROFILE = dev

# 
d__DEFAULTS = $(call list_by_prefix,d__)

CTXES := $(CTXES) d

########################################################################################################################
CTX := cargo_foo
########################################################################################################################
ctx_cargo_foo__ENABLED = yes
ctx_cargo_foo__STAGE = build

cargo_foo__IN = $(MK)/cargo.mk
cargo_foo__OUT_DIR = $(d__OUTDIR)/cargo/foo
cargo_foo__OUT = $(cargo_foo__OUT_DIR)/Makefile

cargo_foo__BINS = foo
cargo_foo__CARGO_TOML = $(d__PROJECT_ROOT)/examples/foo/Cargo.toml

# cargo envs
cargo_foo__env_RUSTFLAGS = $(d__RUSTFLAGS)
cargo_foo__env_BUILD_VERSION = $(d__BUILD_VERSION)

cargo_foo__ENVS = $(call list_by_prefix,cargo_foo__env_)

CTXES := $(CTXES) cargo_foo

########################################################################################################################
CTX := cargo_bar
########################################################################################################################
ctx_cargo_bar__ENABLED = yes
ctx_cargo_bar__STAGE = build

cargo_bar__IN = $(MK)/cargo.mk
cargo_bar__OUT_DIR = $(d__OUTDIR)/cargo/bar
cargo_bar__OUT = $(cargo_bar__OUT_DIR)/Makefile

cargo_bar__BINS = bar
cargo_bar__CARGO_TOML = $(d__PROJECT_ROOT)/examples/bar/Cargo.toml

$(call copy,cargo_foo__env_,cargo_bar__env_)
cargo_bar__env_DATABASE_URL = $(d__PG_DATABASE_URL)

cargo_bar__ENVS = $(call list_by_prefix,cargo_bar__env_)

CTXES := $(CTXES) cargo_bar

########################################################################################################################
CTX := postgresql
########################################################################################################################
ctx_postgresql__ENABLED = $(d_HOST_SERVICES_ENABLED)
ctx_postgresql__STAGE = services

postgresql__IN = $(MK)/postgresql.mk
postgresql__OUT_DIR = $(d__OUTDIR)/services
postgresql__OUT = $(postgresql__OUT_DIR)/pg.mk

CTXES := $(CTXES) postgresql

########################################################################################################################
CTX := redis
########################################################################################################################
ctx_redis__ENABLED = $(d_HOST_SERVICES_ENABLED)
ctx_redis__STAGE = services

redis__IN = $(MK)/redis.mk
redis__OUT_DIR = $(d__OUTDIR)/services
redis__OUT = $(redis__OUT_DIR)/redis.mk

CTXES := $(CTXES) redis

########################################################################################################################
CTX := pg_ctl
########################################################################################################################
ctx_pg_ctl__ENABLED = no
ctx_pg_ctl__STAGE = services

pg_ctl__IN = $(MK)/pg_ctl.mk
pg_ctl__OUT_DIR = $(d__OUTDIR)/services
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/pg_ctl.mk

CTXES := $(CTXES) pg_ctl

########################################################################################################################
CTX := psql
########################################################################################################################
ctx_psql__ENABLED = yes
ctx_psql__STAGE = init

psql__IN = $(MK)/psql.mk
psql__OUT_DIR = $(d__OUTDIR)/psql
psql__OUT = $(psql__OUT_DIR)/psql.mk

CTXES := $(CTXES) psql

########################################################################################################################
CTX := redis_cli
########################################################################################################################
ctx_redis_cli__ENABLED = yes
ctx_redis_cli__STAGE = init

redis_cli__IN = $(MK)/redis-cli.mk
redis_cli__OUT_DIR = $(d__OUTDIR)/redis
redis_cli__OUT = $(redis_cli__OUT_DIR)/redis.mk

CTXES := $(CTXES) redis_cli

########################################################################################################################
CTX := venv_pytest_bar
########################################################################################################################
ctx_venv_pytest_bar__ENABLED = yes
ctx_venv_pytest_bar__STAGE = venvs

venv_pytest_bar__IN = $(MK)/venv.mk
venv_pytest_bar__OUT_DIR = $(d__OUTDIR)/venv/pytest/bar
venv_pytest_bar__OUT = $(venv_pytest_bar__OUT_DIR)/Makefile

venv_pytest_bar__VENV_DIR = $(venv_pytest_bar__OUT_DIR)/.venv
venv_pytest_bar__VENV_PROMT = [VENV]

CTXES := $(CTXES) venv_pytest_bar

########################################################################################################################
CTX := pip_pytest_bar
########################################################################################################################
ctx_pip_pytest_bar__ENABLED = yes
ctx_pip_pytest_bar__STAGE = pip

pip_pytest_bar__IN = $(MK)/pip.mk
pip_pytest_bar__OUT_DIR = $(d__OUTDIR)/pip/pytest/bar
pip_pytest_bar__OUT = $(pip_pytest_bar__OUT_DIR)/Makefile

pip_pytest_bar__PYTHON = $(venv_pytest_bar__VENV_DIR)/bin/python
pip_pytest_bar__REQUIREMENTS = $(d__PROJECT_ROOT)/examples/bar/tests/requirements.txt

CTXES := $(CTXES) pip_pytest_bar

########################################################################################################################
CTX := venv_pytest_foo
########################################################################################################################
ctx_venv_pytest_foo__ENABLED = yes
ctx_venv_pytest_foo__STAGE = venvs

venv_pytest_foo__IN = $(MK)/venv.mk
venv_pytest_foo__OUT_DIR = $(d__OUTDIR)/pytest/foo
venv_pytest_foo__OUT = $(venv_pytest_foo__OUT_DIR)/Makefile

venv_pytest_foo__VENV_DIR = $(venv_pytest_foo__OUT_DIR)/.venv
venv_pytest_foo__VENV_PROMT = [VENV]

CTXES := $(CTXES) venv_pytest_foo

########################################################################################################################
CTX := pip_pytest_foo
########################################################################################################################
ctx_pip_pytest_foo__ENABLED = yes
ctx_pip_pytest_foo__STAGE = pip

pip_pytest_foo__IN = $(MK)/pip.mk
pip_pytest_foo__OUT_DIR = $(d__OUTDIR)/pip/pytest/foo
pip_pytest_foo__OUT = $(pip_pytest_foo__OUT_DIR)/Makefile

pip_pytest_foo__PYTHON = $(venv_pytest_foo__VENV_DIR)/bin/python
pip_pytest_foo__REQUIREMENTS = $(d__PROJECT_ROOT)/examples/foo/tests/requirements.txt

CTXES := $(CTXES) pip_pytest_foo

########################################################################################################################
CTX := python
########################################################################################################################
python__IN = $(MK)/python.mk
python__OUT_DIR = $(d__OUTDIR)/python
python__OUT = $(python__OUT_DIR)/python.mk

CTXES := $(CTXES) python

########################################################################################################################
CTX := rustup
########################################################################################################################
rustup__IN = $(MK)/rustup.mk
rustup__OUT_DIR = $(d__OUTDIR)/rustup
rustup__OUT = $(rustup__OUT_DIR)/rustup.mk

CRATES += cargo-cache
rustup__CARGO_CACHE_VERSION = 0.8.3

CRATES += sqlx-cli
rustup__SQLX_CLI_VERSION = 0.7.1

CTXES := $(CTXES) rustup

########################################################################################################################
CTX := app_sqlx_bar
########################################################################################################################
ctx_app_sqlx_bar__ENABLED = yes
ctx_app_sqlx_bar__STAGE = schemas

app_sqlx_bar__IN = $(MK)/app.mk
app_sqlx_bar__OUT_DIR = $(d__OUTDIR)/sqlx
app_sqlx_bar__OUT = $(app_sqlx_bar__OUT_DIR)/bar.mk

app_sqlx_bar__BIN_PATH = sqlx migrate run
app_sqlx_bar__OPTS = --source "$(d__PROJECT_ROOT)/examples/bar/$(SCHEMAS_DIR)"
app_sqlx_bar__TMUX_START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_sqlx_bar__OUT) tee' WINDOW_NAME=schemas_foo

# sqlx envs
app_sqlx_bar__env_DATABASE_URL = $(d__PG_DATABASE_URL)

app_sqlx_bar__ENVS = $(call list_by_prefix,app_sqlx_bar__env_)

CTXES := $(CTXES) app_sqlx_bar

########################################################################################################################
CTX := venv_alembic_baz
########################################################################################################################
ctx_venv_alembic_baz__ENABLED = yes
ctx_venv_alembic_baz__STAGE = venvs

venv_alembic_baz__IN = $(MK)/venv.mk
venv_alembic_baz__OUT_DIR = $(d__OUTDIR)/alembic/baz
venv_alembic_baz__OUT = $(venv_alembic_baz__OUT_DIR)/Makefile

venv_alembic_baz__VENV_DIR = $(venv_alembic_baz__OUT_DIR)/.venv
venv_alembic_baz__VENV_PROMT = [VENV]

CTXES := $(CTXES) venv_alembic_baz

########################################################################################################################
CTX := pip_alembic_baz
########################################################################################################################
ctx_pip_alembic_baz__ENABLED = yes
ctx_pip_alembic_baz__STAGE = pip

pip_alembic_baz__IN = $(MK)/pip.mk
pip_alembic_baz__OUT_DIR = $(d__OUTDIR)/alembic/baz
pip_alembic_baz__OUT = $(pip_alembic_baz__OUT_DIR)/Makefile

pip_alembic_baz__PYTHON = $(venv_alembic_baz__VENV_DIR)/bin/python
pip_alembic_baz__REQUIREMENTS = $(d__PROJECT_ROOT)/examples/baz/migrator/requirements.txt

CTXES := $(CTXES) pip_alembic_baz

########################################################################################################################
CTX := app_foo
########################################################################################################################
ctx_app_foo__ENABLED = $(d_HOST_APPS_ENABLED)
ctx_app_foo__STAGE = apps

app_foo__IN = $(MK)/app.mk
app_foo__OUT_DIR = $(d__OUTDIR)/app/foo
app_foo__OUT = $(app_foo__OUT_DIR)/Makefile

app_foo__BIN_PATH = $(d__PROJECT_ROOT)/examples/foo/$(call cargo_bins,dev,$(d__CARGO_TARGET_DIR),$(d__RUST_TARGET_ARCH))
app_foo__LOG_FILE = $(app_foo__OUT_DIR)/.foo.logs
app_foo__PID_FILE = $(app_foo__OUT_DIR)/.foo.pid
app_foo__PKILL_PATTERN = $(app_foo__BIN_PATH)
app_foo__MODE = tmux
app_foo__TMUX_START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_foo__OUT) tee' WINDOW_NAME=foo
# app_foo__TMUX_STOP_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_foo__OUT) stop' WINDOW_NAME=foo

# foo envs
app_foo__env_RUST_LOG = foo=debug

app_foo__ENVS = $(call list_by_prefix,app_foo__env_)

CTXES := $(CTXES) app_foo

########################################################################################################################
CTX := app_bar
########################################################################################################################
ctx_app_bar__ENABLED = $(d_HOST_APPS_ENABLED)
ctx_app_bar__STAGE = apps

app_bar__IN = $(MK)/app.mk
app_bar__OUT_DIR = $(d__OUTDIR)/app/bar
app_bar__OUT = $(app_bar__OUT_DIR)/Makefile

app_bar__BIN_PATH = $(d__PROJECT_ROOT)/examples/bar/$(call cargo_bins,dev,$(d__CARGO_TARGET_DIR),$(d__RUST_TARGET_ARCH))
app_bar__LOG_FILE = $(app_bar__OUT_DIR)/.foo.logs
app_bar__PID_FILE = $(app_bar__OUT_DIR)/foo.pid
app_bar__PKILL_PATTERN = $(app_bar__BIN_PATH)
app_bar__MODE = tee
app_bar__TMUX_START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_bar__OUT) tee' WINDOW_NAME=bar
# app_bar__TMUX_STOP_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_bar__OUT) stop' WINDOW_NAME=foo

# bar envs
app_bar__env_RUST_LOG = bar=debug

app_bar__ENVS = $(call list_by_prefix,app_bar__env_)

CTXES := $(CTXES) app_bar

########################################################################################################################
CTX := pytest_bar
########################################################################################################################
ctx_pytest_bar__ENABLED = yes
ctx_pytest_bar__STAGE = tests

pytest_bar__IN = $(MK)/pytest.mk
pytest_bar__OUT_DIR = $(d__OUTDIR)/pytest/bar
pytest_bar__OUT = $(pytest_bar__OUT_DIR)/Makefile

pytest_bar__TEST_CASES_DIR = $(d__PROJECT_ROOT)/examples/bar/tests
pytest_bar__PYTHON = $(venv_pytest_bar__VENV_DIR)/bin/python

pytest_bar__MODE = tmux
pytest_bar__TMUX_START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(pytest_bar__OUT) run' WINDOW_NAME=tests_bar

pytest_bar__ENVS = 

CTXES := $(CTXES) pytest_bar

########################################################################################################################
CTX := pytest_foo
########################################################################################################################
ctx_pytest_foo__ENABLED = yes
ctx_pytest_foo__STAGE = tests

pytest_foo__IN = $(MK)/pytest.mk
pytest_foo__OUT_DIR = $(d__OUTDIR)/pytest/foo
pytest_foo__OUT = $(pytest_foo__OUT_DIR)/Makefile

pytest_foo__TEST_CASES_DIR = $(d__PROJECT_ROOT)/examples/foo/tests
pytest_foo__PYTHON = $(venv_pytest_foo__VENV_DIR)/bin/python

pytest_foo__ENVS = 

CTXES := $(CTXES) pytest_foo

########################################################################################################################
CTX := tmux
########################################################################################################################
ctx_tmux__ENABLED = yes
ctx_tmux__STAGE = tmux

tmux__IN = $(MK)/tmux.mk
tmux__OUT_DIR = $(d__OUTDIR)/tmux
tmux__OUT = $(tmux__OUT_DIR)/Makefile

CTXES := $(CTXES) tmux

########################################################################################################################
CTX := docker_pg
########################################################################################################################
ctx_docker_pg__ENABLED = $(d_DOCKER_SERVICES_ENABLED)
ctx_docker_pg__STAGE = services

docker_pg__IN = $(MK)/docker.mk
docker_pg__OUT_DIR = $(d__OUTDIR)/docker
docker_pg__OUT = $(docker_pg__OUT_DIR)/pg.mk

docker_pg__CONTAINER = pg
docker_pg__CTX = $(d__PROJECT_ROOT)
docker_pg__RESTART_POLICY = always
docker_pg__RM_AFTER_STOP = no

# build args for docker build
docker_pg__arg_BASE_IMAGE = $(DOCKER_PG_IMAGE)

docker_pg__BUILD_ARGS = $(call list_by_prefix,docker_pg__arg_)

# envs for docker run
docker_pg__env_POSTGRES_PASSWORD = $(ADMIN_PASSWORD)
docker_pg__env_POSTGRES_DB = $(ADMIN_DB)
docker_pg__env_POSTGRES_USER = $(ADMIN)

docker_pg__ENVS = $(call list_by_prefix,docker_pg__env_)

CTXES := $(CTXES) docker_pg

########################################################################################################################
CTX := docker_redis
########################################################################################################################
ctx_docker_redis__ENABLED = $(d_DOCKER_SERVICES_ENABLED)
ctx_docker_redis__STAGE = services

docker_redis__IN = $(MK)/docker.mk
docker_redis__OUT_DIR = $(d__OUTDIR)/docker
docker_redis__OUT = $(docker_redis__OUT_DIR)/redis.mk

docker_redis__CONTAINER = redis
docker_redis__CTX = $(d__PROJECT_ROOT)
docker_redis__RESTART_POLICY = always
docker_redis__RM_AFTER_STOP = no

# docker build_args
docker_redis__arg_BASE_IMAGE = $(d__DOCKER_REDIS_IMAGE)

docker_redis__BUILD_ARGS = $(call list_by_prefix,docker_redis__arg_)

docker_redis__ENVS = 

CTXES := $(CTXES) docker_redis

########################################################################################################################
CTX := docker_rust
########################################################################################################################
ctx_docker_rust__ENABLED = $(d_DOCKER_SERVICES_ENABLED)
ctx_docker_rust__STAGE = build

docker_rust__IN = $(MK)/docker.mk
docker_rust__OUT_DIR = $(d__OUTDIR)/docker
docker_rust__OUT = $(docker_rust__OUT_DIR)/rust.mk

docker_rust__CONTAINER = builder_rust
docker_rust__CTX = $(d__PROJECT_ROOT)
docker_rust__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust
docker_rust__TAG = latest
docker_rust__IMAGE = $(call docker_image,rust,$(docker_rust__TAG))
docker_rust__PUBLISH = 8081:80/tcp

# docker build_args
docker_rust__arg_BASE_IMAGE = $(d__DOCKER_ALPINE_IMAGE)
docker_rust__arg_RUST_VERSION = $(d__DOCKER_RUST_VERSION)
docker_rust__arg_TARGET_ARCH = $(d__DOCKER_RUST_TARGET_ARCH)
docker_rust__arg_SQLX_VERSION = 0.7.1

docker_rust__BUILD_ARGS = $(call list_by_prefix,docker_rust__arg_)

docker_rust__ENVS = 

CTXES := $(CTXES) docker_rust

########################################################################################################################
CTX := docker_bar
########################################################################################################################
ctx_docker_bar__ENABLED = $(d_DOCKER_APPS_ENABLED)
ctx_docker_bar__STAGE = apps

docker_bar__IN = $(MK)/docker.mk
docker_bar__OUT_DIR = $(d__OUTDIR)/docker
docker_bar__OUT = $(docker_bar__OUT_DIR)/bar.mk

docker_bar__CONTAINER = bar
docker_bar__CTX = $(d__PROJECT_ROOT)
docker_bar__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_bar__PUBLISH = 8081:80/tcp
docker_bar__IMAGE = $(call docker_image,bar,$(docker_bar__TAG))

# docker build_args
docker_bar__arg_APP = bar
docker_bar__arg_BUILDER = $(docker_rust__IMAGE)
docker_bar__arg_BUILD_PROFILE = $(d__CARGO_PROFILE)
docker_bar__arg_BUILD_VERSION = $(d__BUILD_VERSION)
docker_bar__arg_TARGET_ARCH = $(d__DOCKER_RUST_TARGET_ARCH)
docker_bar__arg_BASE_IMAGE = $(d__DOCKER_ALPINE_IMAGE)

docker_bar__BUILD_ARGS = $(call list_by_prefix,docker_bar__arg_)

# docker envs
$(call copy,app_bar__env_,docker_bar__env_)

docker_bar__ENVS = $(call list_by_prefix,docker_bar__env_)

CTXES := $(CTXES) docker_bar

########################################################################################################################
CTX := docker_foo
########################################################################################################################
ctx_docker_foo__ENABLED = $(d_DOCKER_APPS_ENABLED)
ctx_docker_foo__STAGE = apps

docker_foo__IN = $(MK)/docker.mk
docker_foo__OUT_DIR = $(d__OUTDIR)/docker
docker_foo__OUT = $(docker_foo__OUT_DIR)/foo.mk

docker_foo__CONTAINER = foo
docker_foo__CTX = $(d__PROJECT_ROOT)
docker_foo__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_foo__PUBLISH = 8081:80/tcp
docker_foo__IMAGE = $(call docker_image,foo,$(docker_foo__TAG))

# docker build_args
docker_foo__arg_APP = foo
docker_foo__arg_BUILDER = $(docker_rust__IMAGE)
docker_foo__arg_BUILD_PROFILE = $(d__CARGO_PROFILE)
docker_foo__arg_BUILD_VERSION = $(d__BUILD_VERSION)
docker_foo__arg_TARGET_ARCH = $(d__DOCKER_RUST_TARGET_ARCH)
docker_foo__arg_BASE_IMAGE = $(d__DOCKER_ALPINE_IMAGE)

docker_foo__BUILD_ARGS = $(call list_by_prefix,docker_foo__arg_)

# docker envs
$(call copy,app_foo__env_,docker_foo__env_)

docker_foo__ENVS = $(call list_by_prefix,docker_foo__env_)

CTXES := $(CTXES) docker_foo

########################################################################################################################
CTX := stand_example
########################################################################################################################
stand_example__IN = $(DOCKER_COMPOSE)/stand.yaml
stand_example__OUT_DIR = $(d__OUTDIR)/compose
stand_example__OUT = $(stand_example__OUT_DIR)/example.yaml

# RUST
stand_example__RUST = rust
stand_example__RUST_BASE_IMAGE = $(docker_rust__BASE_IMAGE) 
stand_example__RUST_CTX = $(docker_rust__CTX)
stand_example__RUST_DOCKERFILE = $(docker_rust__DOCKERFILE)
stand_example__RUST_IMAGE = $(docker_rust__IMAGE)
stand_example__RUST_VERSION = $(docker_rust__RUST_VERSION) 
stand_example__SQLX_VERSION = $(docker_rust__SQLX_VERSION)
stand_example__TARGET_ARCH = $(docker_rust__TARGET_ARCH) 

# BAR
stand_example__BAR = bar
stand_example__BAR_RESTART_POLICY = $(docker_bar__RESTART_POLICY)
stand_example__BAR_BASE_IMAGE = $(docker_bar__BASE_IMAGE)
stand_example__BAR_BRIDGE = $(stand_example__BRIDGE)
stand_example__BAR_BUILD_PROFILE = $(docker_bar__BUILD_PROFILE)
stand_example__BAR_BUILD_VERSION = $(docker_bar__BUILD_VERSION)
stand_example__BAR_BUILDER = $(stand_example__RUST_IMAGE)
stand_example__BAR_CTX = $(docker_bar__CTX)
stand_example__BAR_DOCKERFILE = $(docker_bar__DOCKERFILE)
stand_example__BAR_IMAGE = $(docker_bar__IMAGE)
stand_example__BAR_PUBLISH = $(docker_bar__PUBLISH)
stand_example__BAR_TARGET_ARCH = $(docker_bar__TARGET_ARCH)
stand_example__XX = 98765
stand_example__YYY = qwerty

# FOO
stand_example__FOO = foo
stand_example__FOO_RESTART_POLICY = $(docker_foo__RESTART_POLICY)
stand_example__FOO_BASE_IMAGE = $(docker_foo__BASE_IMAGE)
stand_example__FOO_BRIDGE = $(stand_example__BRIDGE)
stand_example__FOO_BUILD_PROFILE = $(docker_foo__BUILD_PROFILE)
stand_example__FOO_BUILD_VERSION = $(docker_foo__BUILD_VERSION)
stand_example__FOO_BUILDER = $(stand_example__RUST_IMAGE)
stand_example__FOO_CTX = $(docker_foo__CTX)
stand_example__FOO_DOCKERFILE = $(docker_foo__DOCKERFILE)
stand_example__FOO_IMAGE = $(docker_foo__IMAGE)
stand_example__FOO_PUBLISH = $(docker_foo__PUBLISH)
stand_example__FOO_TARGET_ARCH = $(docker_foo__TARGET_ARCH)
stand_example__WWW = 98765
stand_example__YY = qwerty

# PG
stand_example__PG = pg
stand_example__PG_RESTART_POLICY = $(docker_pg__RESTART_POLICY)
stand_example__PG_IMAGE = $(docker_pg__BASE_IMAGE)
stand_example__PG_PUBLISH = $(docker_pg__PUBLISH)
stand_example__PG_BRIDGE = $(stand_example__BRIDGE)
stand_example__POSTGRES_PASSWORD = $(docker_pg__)
stand_example__POSTGRES_DB = $(docker_pg__POSTGRES_DB)
stand_example__POSTGRES_USER = $(docker_pg__POSTGRES_USER)

# REDIS
stand_example__REDIS = redis
stand_example__REDIS_RESTART_POLICY = $(docker_redis__RESTART_POLICY)
stand_example__REDIS_ADMIN_PASSWORD = $(d__REDIS_ADMIN_PASSWORD)
stand_example__REDIS_IMAGE = $(docker_redis__BASE_IMAGE)
stand_example__REDIS_PUBLISH = $(docker_redis__PUBLISH)
stand_example__REDIS_BRIDGE = $(stand_example__BRIDGE)

# NETWORKS
stand_example__BRIDGE = example
stand_example__DRIVER = $(DOCKER_NETWORK_DRIVER)
stand_example__NETWORK = 192.168.200.0/24

# PG_ENVS
stand_example__PG_ENVS = $(call list_by_prefix,docker_pg__env_)

# BAR_ENVS
stand_example__BAR_ENVS = XX YYY

# FOO_ENVS
stand_example__FOO_ENVS = WWW YY

CTXES := $(CTXES) stand_example

# ########################################################################################################################
CTX := compose_example
# ########################################################################################################################
compose_example__IN = $(MK)/compose.mk
compose_example__OUT_DIR = $(d__OUTDIR)/compose
compose_example__OUT = $(compose_example__OUT_DIR)/example.mk

CTXES := $(CTXES) compose_example

########################################################################################################################
CTX := end
########################################################################################################################