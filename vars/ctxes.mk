DOCKERFILES = $(DEVTOOLS_DIR)/dockerfiles
TMPL_DIR = $(DEVTOOLS_DIR)/templates
MK = $(TMPL_DIR)/make
DOCKER_COMPOSE = $(TMPL_DIR)/compose

########################################################################################################################
CTX := cargo_foo
########################################################################################################################
ctx_cargo_foo__ENABLED = yes
ctx_cargo_foo__STAGE = build

cargo_foo__IN = $(MK)/cargo.mk
cargo_foo__OUT_DIR = $(OUT_DIR)/cargo/foo
cargo_foo__OUT = $(cargo_foo__OUT_DIR)/Makefile

cargo_foo__BINS = foo
cargo_foo__CLIPPY_FORMAT = $(CARGO_CLIPPY_FORMAT)
cargo_foo__CLIPPY_REPORT = $(CARGO_CLIPPY_REPORT)
cargo_foo__FEATURES = $(CARGO_FEATURES)
cargo_foo__INSTALL_DIR = $(CARGO_INSTALL_DIR)
cargo_foo__LIB = $(LIB)
cargo_foo__LINTS = $(CARGO_LINTS)
cargo_foo__PROFILE = $(CARGO_PROFILE)
cargo_foo__TARGET_ARCH = $(RUST_TARGET_ARCH)
cargo_foo__TARGET_DIR = $(CARGO_TARGET_DIR)
cargo_foo__TOML = $(CARGO_TOML)

ifeq ($(cargo_foo__PROFILE),dev)
	cargo_foo__PROFILE_DIR = debug
else
	cargo_foo__PROFILE_DIR = $(PROFILE)
endif

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
cargo_foo__BINS_DIR = $(abspath $(cargo_foo__TARGET_DIR))/$(cargo_foo__TARGET_ARCH)/$(cargo_foo__PROFILE_DIR)

# cargo envs
envs_cargo_foo__RUSTFLAGS = $(RUSTFLAGS)
envs_cargo_foo__BUILD_VERSION = $(BUILD_VERSION)

cargo_foo__ENVS = $(foreach VAR,$(filter envs_cargo_foo__%,$(.VARIABLES)),$(subst envs_cargo_foo__,,$(VAR)))

CTXES := $(CTXES) cargo_foo

########################################################################################################################
CTX := cargo_bar
########################################################################################################################
ctx_cargo_bar__ENABLED = yes
ctx_cargo_bar__STAGE = build

cargo_bar__IN = $(MK)/cargo.mk
cargo_bar__OUT_DIR = $(OUT_DIR)/cargo/bar
cargo_bar__OUT = $(cargo_bar__OUT_DIR)/Makefile

cargo_bar__BINS = bar
cargo_bar__CLIPPY_FORMAT = $(CARGO_CLIPPY_FORMAT)
cargo_bar__CLIPPY_REPORT = $(CARGO_CLIPPY_REPORT)
cargo_bar__FEATURES = $(CARGO_FEATURES)
cargo_bar__INSTALL_DIR = $(CARGO_INSTALL_DIR)
cargo_bar__LIB = $(LIB)
cargo_bar__LINTS = $(CARGO_LINTS)
cargo_bar__PROFILE = $(CARGO_PROFILE)
cargo_bar__TARGET_ARCH = $(RUST_TARGET_ARCH)
cargo_bar__TARGET_DIR = $(CARGO_TARGET_DIR)
cargo_bar__TOML = $(CARGO_TOML)

ifeq ($(cargo_bar__PROFILE),dev)
	cargo_bar__PROFILE_DIR = debug
else
	cargo_bar__PROFILE_DIR = $(PROFILE)
endif

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
cargo_bar__BINS_DIR = $(abspath $(cargo_bar__TARGET_DIR))/$(cargo_bar__TARGET_ARCH)/$(cargo_bar__PROFILE_DIR)

# cargo envs

# inherit envs from CTX envs_cargo_foo__
$(foreach VAR,$(filter envs_cargo_foo__%,$(.VARIABLES)), \
    $(eval envs_cargo_bar__$(subst envs_cargo_foo__,,$(VAR)) = $($(VAR))) \
)

# envs_cargo_bar__RUSTFLAGS = $(RUSTFLAGS)
# envs_cargo_bar__BUILD_VERSION = $(BUILD_VERSION)
envs_cargo_bar__DATABASE_URL = $(DATABASE_URL)

cargo_bar__ENVS = $(foreach VAR,$(filter envs_cargo_bar__%,$(.VARIABLES)),$(subst envs_cargo_bar__,,$(VAR)))

CTXES := $(CTXES) cargo_bar

########################################################################################################################
CTX := postgresql
########################################################################################################################
postgresql__IN = $(MK)/postgresql.mk
postgresql__OUT_DIR = $(OUT_DIR)/postgresql
postgresql__OUT = $(postgresql__OUT_DIR)/Makefile

postgresql__AUTH_POLICY = host  all  all  $(REMOTE_PREFIX)  md5
postgresql__MAJOR = 12
postgresql__MINOR = 15_2
postgresql__OS = ubuntu
postgresql__OS_CODENAME = $(OS_CODENAME)
postgresql__PG_HBA = /etc/postgresql/$(postgresql__MAJOR)/main/pg_hba.conf
postgresql__REMOTE_PREFIX = 0.0.0.0/0
postgresql__SUDO_BIN = $(SUDO)
postgresql__SUDO_USER =
postgresql__VERSION = $(postgresql__MAJOR).$(postgresql__MINOR)

CTXES := $(CTXES) postgresql

########################################################################################################################
CTX := service_pg
########################################################################################################################
ctx_service_pg__ENABLED = yes
ctx_service_pg__STAGE = os_services

service_pg__IN = $(MK)/exec.mk
service_pg__OUT_DIR = $(OUT_DIR)/services
service_pg__OUT = $(service_pg__OUT_DIR)/pg.mk

service_pg__SERVICE = postgresql@12
service_pg__START_CMD = $(SERVICE_START_CMD) $(service_pg__SERVICE)
service_pg__STOP_CMD = $(SERVICE_STOP_CMD) $(service_pg__SERVICE)

CTXES := $(CTXES) service_pg

########################################################################################################################
CTX := pg_ctl
########################################################################################################################
pg_ctl__IN = $(MK)/pg_ctl.mk
pg_ctl__OUT_DIR = $(OUT_DIR)/pg_ctl
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/Makefile

pg_ctl__ADMIN = $(PG_ADMIN)
pg_ctl__ADMIN_DB = $(PG_ADMIN_DB)
pg_ctl__ADMIN_PASSWORD = $(PG_ADMIN_PASSWORD)
pg_ctl__DATADIR = $(pg_ctl__OUT_DIR)/pg_data
pg_ctl__HOST = $(LOCALHOST)
pg_ctl__INITDB_AUTH_HOST = md5
pg_ctl__INITDB_AUTH_LOCAL = peer
pg_ctl__INITDB_PWFILE = /tmp/passwd.tmp
pg_ctl__LANG = $(LOCALE_LANG)
pg_ctl__LC_ALL = $(LOCALE_LC_ALL)
pg_ctl__LC_CTYPE = $(LOCALE_LC_CTYPE)
pg_ctl__OS_USER = $(PG_ADMIN)
pg_ctl__PG_CONFIG = $(PG_CONFIG)
pg_ctl__PG_CTL_CONF = $(pg_ctl__DATADIR)/postgresql.conf
pg_ctl__PG_CTL_LOG = $(pg_ctl__DATADIR)/pg_ctl.log
pg_ctl__PG_CTL_LOGGING_COLLECTOR = on
pg_ctl__PORT = $(PG_PORT)
pg_ctl__SUDO_BIN = $(SUDO)
pg_ctl__SUDO_USER = $(PG_ADMIN)

CTXES := $(CTXES) pg_ctl

########################################################################################################################
CTX := service_pg_ctl
########################################################################################################################
ctx_service_pg_ctl__ENABLED = yes
ctx_service_pg_ctl__STAGE = sysctl

service_pg_ctl__IN = $(MK)/exec.mk
service_pg_ctl__OUT_DIR = $(OUT_DIR)/services
service_pg_ctl__OUT = $(service_pg_ctl__OUT_DIR)/pg_ctl.mk

service_pg_ctl__SERVICE = pg_ctl
service_pg_ctl__START_CMD = make -f $(pg_ctl__OUT) start
service_pg_ctl__STOP_CMD = make -f $(pg_ctl__OUT) stop

CTXES := $(CTXES) service_pg_ctl

########################################################################################################################
CTX := psql
########################################################################################################################
psql__IN = $(MK)/psql.mk
psql__OUT_DIR = $(OUT_DIR)/psql
psql__OUT = $(psql__OUT_DIR)/Makefile

psql__ADMIN = $(PG_ADMIN)
psql__ADMIN_DB = $(PG_ADMIN_DB)
psql__ADMIN_PASSWORD = $(PG_ADMIN_PASSWORD)
psql__ARTEFACTS_DIR = $(psql__OUT_DIR)/.artefacts
psql__AUTH_METHOD = remote
psql__CNT =
psql__EXIT_IF_CREATE_EXISTED_DB = no
psql__EXIT_IF_CREATE_EXISTED_USER = no
psql__HOST = $(LOCALHOST)
psql__LIB = $(LIB)
psql__MODE = $(MODE)
psql__PORT = $(PG_PORT)
psql__SUDO_BIN = $(SUDO)
psql__SUDO_USER =
psql__USER_ATTRIBUTES = SUPERUSER CREATEDB
psql__USER_DB = $(SERVICE_DB)
psql__USER_NAME = $(SERVICE_USER)
psql__USER_PASSWORD = $(SERVICE_PASSWORD)

CTXES := $(CTXES) psql

########################################################################################################################
CTX := redis
########################################################################################################################
redis__IN = $(MK)/redis-cli.mk
redis__OUT_DIR = $(OUT_DIR)/redis
redis__OUT = $(redis__OUT_DIR)/Makefile

redis__ADMIN = $(REDIS_ADMIN)
redis__ADMIN_DB = $(REDIS_ADMIN_DB)
redis__ADMIN_PASSWORD = $(REDIS_ADMIN_PASSWORD)
redis__ARTEFACTS_DIR = $(redis__OUT_DIR)/.artefacts
redis__CONTAINER =
redis__HOST = $(LOCALHOST)
redis__MODE = $(MODE)
redis__PORT = $(REDIS_PORT)
redis__REQUIREPASS = yes
redis__USER_DB = $(SERVICE_DB)
redis__USER_NAME = $(SERVICE_USER)
redis__USER_PASSWORD = $(SERVICE_PASSWORD)

CTXES := $(CTXES) redis

########################################################################################################################
CTX := service_redis
########################################################################################################################
ctx_service_redis__ENABLED = yes
ctx_service_redis__STAGE = sysctl

service_redis__IN = $(MK)/exec.mk
service_redis__OUT_DIR = $(OUT_DIR)/services
service_redis__OUT = $(service_redis__OUT_DIR)/redis.mk

service_redis__SERVICE = redis
service_redis__START_CMD = $(SERVICE_START_CMD) $(service_redis__SERVICE)
service_redis__STOP_CMD = $(SERVICE_STOP_CMD) $(service_redis__SERVICE)

CTXES := $(CTXES) service_redis

########################################################################################################################
CTX := venv_pytest_bar
########################################################################################################################
ctx_venv_pytest_bar__ENABLED = yes
ctx_venv_pytest_bar__STAGE = venv

venv_pytest_bar__IN = $(MK)/venv.mk
venv_pytest_bar__OUT_DIR = $(OUT_DIR)/pytest/venvs
venv_pytest_bar__OUT = $(venv_pytest_bar__OUT_DIR)/bar.mk

venv_pytest_bar__VENV_DIR = $(venv_pytest_bar__OUT_DIR)/.bar
venv_pytest_bar__PYTHON = $(PYTHON)
venv_pytest_bar__VENV_PROMT = [VENV]

CTXES := $(CTXES) venv_pytest_bar

########################################################################################################################
CTX := pip_pytest_bar
########################################################################################################################
ctx_pip_pytest_bar__ENABLED = yes
ctx_pip_pytest_bar__STAGE = pip

pip_pytest_bar__IN = $(MK)/pip.mk
pip_pytest_bar__OUT_DIR = $(OUT_DIR)/pytest/pips
pip_pytest_bar__OUT = $(pip_pytest_bar__OUT_DIR)/bar.mk

pip_pytest_bar__ARTEFACTS_DIR = $(pip_pytest_bar__OUT_DIR)/.artefacts
pip_pytest_bar__CC = $(CC)
pip_pytest_bar__CPPFLAGS = $(CPPFLAGS)
pip_pytest_bar__CXX = $(CXX)
pip_pytest_bar__INSTALL_SCHEMA =
pip_pytest_bar__LDFLAGS = $(LDFLAGS)
pip_pytest_bar__PYTHON = $(venv_pytest_bar__VENV_DIR)/bin/python
pip_pytest_bar__REQUIREMENTS = $(PROJECT_ROOT)/apps/bar/tests/requirements.txt
pip_pytest_bar__USERBASE =

CTXES := $(CTXES) pip_pytest_bar

########################################################################################################################
CTX := python
########################################################################################################################
python__IN = $(MK)/py.mk
python__OUT_DIR = $(OUT_DIR)/python
python__OUT = $(python__OUT_DIR)/Makefile

python__DL = $(python__OUT_DIR)/.dl
python__MAJOR = 3.11
python__MINOR = 4
python__OWNER = $(USER)
python__PREFIX =
python__SUDO = $(SUDO)

CTXES := $(CTXES) python

########################################################################################################################
CTX := rustup
########################################################################################################################
rustup__IN = $(MK)/rustup.mk
rustup__OUT_DIR = $(OUT_DIR)/rustup
rustup__OUT = $(rustup__OUT_DIR)/Makefile

rustup__CARGO_CACHE ?= no
rustup__CARGO_CACHE_VERSION = 0.8.3
rustup__LIB = $(LIB)
rustup__RUST_VERSION = $(RUST_VERSION)
rustup__RUSTFLAGS = $(RUSTFLAGS)
rustup__SQLX ?= yes
rustup__SQLX_VERSION = 0.7.1
rustup__TARGET_ARCH = $(RUST_TARGET_ARCH)

CTXES := $(CTXES) rustup

########################################################################################################################
CTX := app_sqlx_bar
########################################################################################################################
ctx_app_sqlx_bar__ENABLED = yes
ctx_app_sqlx_bar__STAGE = schemas

app_sqlx_bar__IN = $(MK)/app.mk
app_sqlx_bar__OUT_DIR = $(OUT_DIR)/schemas/
app_sqlx_bar__OUT = $(app_sqlx_bar__OUT_DIR)/app.mk

app_sqlx_bar__ARTEFACTS_DIR = $(app_sqlx_bar__OUT_DIR)/.sqlx-artefacts
app_sqlx_bar__BIN_PATH = sqlx migrate run
app_sqlx_bar__LOG_FILE = $(app_sqlx_bar__ARTEFACTS_DIR)/logs.txt
app_sqlx_bar__OPTS = --source "$(PROJECT_ROOT)/apps/bar/$(SCHEMAS_DIR)"
app_sqlx_bar__PID_FILE = $(app_sqlx_bar__ARTEFACTS_DIR)/.pid
app_sqlx_bar__PKILL_PATTERN =

# sqlx envs
envs_app_sqlx_bar__DATABASE_URL = $(DATABASE_URL)

app_sqlx_bar__ENVS = $(foreach VAR,$(filter envs_app_sqlx_bar__%,$(.VARIABLES)),$(subst envs_app_sqlx_bar__,,$(VAR)))

CTXES := $(CTXES) app_sqlx_bar

########################################################################################################################
CTX := app_foo
########################################################################################################################
ctx_app_foo__ENABLED = no
ctx_app_foo__STAGE = apps

app_foo__IN = $(MK)/app.mk
app_foo__OUT_DIR = $(OUT_DIR)/apps
app_foo__OUT = $(app_foo__OUT_DIR)/foo.mk

app_foo__ARTEFACTS_DIR = $(app_foo__OUT_DIR)/.artefacts
app_foo__BIN_PATH = $(cargo_foo__BINS_DIR)/foo
app_foo__ENVS =
app_foo__LOG_FILE = $(app_foo__ARTEFACTS_DIR)/logs.txt
app_foo__OPTS =
app_foo__PID_FILE = $(app_foo__ARTEFACTS_DIR)/.pid
app_foo__PKILL_PATTERN = $(app_foo__BIN_PATH)

CTXES := $(CTXES) app_foo

########################################################################################################################
CTX := tmux_app_foo
########################################################################################################################
ctx_tmux_app_foo__ENABLED = yes
ctx_tmux_app_foo__STAGE = apps

tmux_app_foo__IN = $(MK)/exec.mk
tmux_app_foo__OUT_DIR = $(OUT_DIR)/tmux
tmux_app_foo__OUT = $(tmux_app_foo__OUT_DIR)/foo.mk

tmux_app_foo__SERVICE = app_foo
tmux_app_foo__START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_foo__OUT) start' WINDOW_NAME=foo
tmux_app_foo__STOP_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_foo__OUT) stop' WINDOW_NAME=foo

CTXES := $(CTXES) tmux_app_foo

########################################################################################################################
CTX := app_bar
########################################################################################################################
ctx_app_bar__ENABLED = no
ctx_app_bar__STAGE = apps

app_bar__IN = $(MK)/app.mk
app_bar__OUT_DIR = $(OUT_DIR)/apps
app_bar__OUT = $(app_bar__OUT_DIR)/bar.mk

app_bar__ARTEFACTS_DIR = $(app_bar__OUT_DIR)/.artefacts
app_bar__BIN_PATH = $(cargo_bar__BINS_DIR)/bar
app_bar__ENVS =
app_bar__LOG_FILE = $(app_bar__ARTEFACTS_DIR)/logs.txt
app_bar__OPTS =
app_bar__PID_FILE = $(app_bar__ARTEFACTS_DIR)/.pid
app_bar__PKILL_PATTERN = $(app_bar__BIN_PATH)

CTXES := $(CTXES) app_bar

########################################################################################################################
CTX := tmux_app_bar
########################################################################################################################
ctx_tmux_app_bar__ENABLED = yes
ctx_tmux_app_bar__STAGE = apps

tmux_app_bar__IN = $(MK)/exec.mk
tmux_app_bar__OUT_DIR = $(OUT_DIR)/tmux
tmux_app_bar__OUT = $(tmux_app_bar__OUT_DIR)/bar.mk

tmux_app_bar__SERVICE = app_bar
tmux_app_bar__START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_bar__OUT) start' WINDOW_NAME=foo
tmux_app_bar__STOP_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(app_bar__OUT) stop' WINDOW_NAME=foo

CTXES := $(CTXES) tmux_app_bar

########################################################################################################################
CTX := pytest_bar
########################################################################################################################
ctx_pytest_bar__ENABLED = yes
ctx_pytest_bar__STAGE = tests

pytest_bar__IN = $(MK)/pytest.mk
pytest_bar__OUT_DIR = $(OUT_DIR)/pytest
pytest_bar__OUT = $(pytest_bar__OUT_DIR)/bar.mk

pytest_bar__ARTEFACTS_DIR = $(pytest_bar__OUT_DIR)/.artefacts
pytest_bar__ENVS =
pytest_bar__LOG_FILE = $(pytest_bar__ARTEFACTS_DIR)/logs.txt
pytest_bar__REPORTS_DIR = $(pytest_bar__ARTEFACTS_DIR)/.reports
pytest_bar__TEST_CASES =
pytest_bar__TEST_CASES_DIR = $(PROJECT_ROOT)/tests
pytest_bar__PYTHON = $(venv_pytest_bar__VENV_DIR)/bin/python

CTXES := $(CTXES) pytest_bar

########################################################################################################################
CTX := tmux
########################################################################################################################
ctx_tmux__ENABLED = yes
ctx_tmux__STAGE = tmux

tmux__IN = $(MK)/tmux.mk
tmux__OUT_DIR = $(OUT_DIR)/tmux
tmux__OUT = $(tmux__OUT_DIR)/Makefile

tmux__ARTEFACTS_DIR = $(tmux__OUT_DIR)/.artefacts
tmux__DEFAULT_CMD = $(SH)
tmux__DEFAULT_TERM = xterm-256color
tmux__HISTORY_LIMIT = 1000000
tmux__LOGS_DIR = $(tmux__ARTEFACTS_DIR)
tmux__SESSION_NAME = DEV-TOOLS
tmux__TERM_SIZE = 240x32

CTXES := $(CTXES) tmux

########################################################################################################################
CTX := docker_pg
########################################################################################################################
ctx_docker_pg__ENABLED = yes
ctx_docker_pg__STAGE = docker

docker_pg__IN = $(MK)/docker.mk
docker_pg__OUT_DIR = $(OUT_DIR)/docker
docker_pg__OUT = $(docker_pg__OUT_DIR)/pg.mk

docker_pg__BRIDGE = $(DOCKER_NETWORK_NAME)
docker_pg__CONTAINER = db
docker_pg__CTX = $(PROJECT_ROOT)
docker_pg__DOCKERFILE = $(DOCKERFILES)/Dockerfile
docker_pg__DRIVER = $(DOCKER_NETWORK_DRIVER)
docker_pg__ERR_IF_BRIDGE_EXISTS = yes
docker_pg__PUBLISH = $(PG_PORT):$(PG_PORT)/tcp
docker_pg__SUBNET = $(DOCKER_NETWORK_SUBNET)
docker_pg__TAG = latest

ifdef docker_pg__TAG
    docker_pg__IMAGE = pg:$(docker_pg__TAG)
else
    docker_pg__IMAGE = pg
endif

# docker build_args
envs_docker_pg__BASE_IMAGE = $(DOCKER_PG_IMAGE)

docker_pg__ENVS = $(foreach VAR,$(filter envs_docker_pg__%,$(.VARIABLES)),$(subst envs_docker_pg__,,$(VAR)))

docker_pg__BUILD_ARGS = BASE_IMAGE

CTXES := $(CTXES) docker_pg

########################################################################################################################
CTX := docker_redis
########################################################################################################################
ctx_docker_redis__ENABLED = yes
ctx_docker_redis__STAGE = docker

docker_redis__IN = $(MK)/docker.mk
docker_redis__OUT_DIR = $(OUT_DIR)/docker
docker_redis__OUT = $(docker_redis__OUT_DIR)/redis.mk

docker_redis__BRIDGE = $(DOCKER_NETWORK_NAME)
docker_redis__CONTAINER = redis
docker_redis__CTX = $(PROJECT_ROOT)
docker_redis__DOCKERFILE = $(DOCKERFILES)/Dockerfile
docker_redis__DRIVER = $(DOCKER_NETWORK_DRIVER)
docker_redis__ERR_IF_BRIDGE_EXISTS = yes
docker_redis__PUBLISH = $(REDIS_PORT):$(REDIS_PORT)/tcp
docker_redis__SUBNET = $(DOCKER_NETWORK_SUBNET)
docker_redis__TAG = latest

ifdef docker_redis__TAG
    docker_redis__IMAGE = redis:$(docker_redis__TAG)
else
    docker_redis__IMAGE = redis
endif

# docker build_args
envs_docker_redis__BASE_IMAGE = $(DOCKER_REDIS_IMAGE)

docker_redis__ENVS = $(foreach VAR,$(filter envs_docker_redis__%,$(.VARIABLES)),$(subst envs_docker_redis__,,$(VAR)))

docker_redis__BUILD_ARGS = BASE_IMAGE

CTXES := $(CTXES) docker_redis

########################################################################################################################
CTX := docker_rust
########################################################################################################################
ctx_docker_rust__ENABLED = yes
ctx_docker_rust__STAGE = docker

docker_rust__IN = $(MK)/docker.mk
docker_rust__OUT_DIR = $(OUT_DIR)/docker
docker_rust__OUT = $(docker_rust__OUT_DIR)/rust.mk

docker_rust__BRIDGE = $(DOCKER_NETWORK_NAME)
docker_rust__CONTAINER = builder_rust
docker_rust__CTX = $(PROJECT_ROOT)
docker_rust__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust
docker_rust__DRIVER = $(DOCKER_NETWORK_DRIVER)
docker_rust__ERR_IF_BRIDGE_EXISTS = yes
docker_rust__PUBLISH =
docker_rust__SUBNET = $(DOCKER_NETWORK_SUBNET)
docker_rust__TAG = latest

ifdef docker_rust__TAG
    docker_rust__IMAGE = rust:$(docker_rust__TAG)
else
    docker_rust__IMAGE = rust
endif

# docker build_args
envs_docker_rust__BASE_IMAGE = $(DOCKER_ALPINE_IMAGE)
envs_docker_rust__RUST_VERSION = $(DOCKER_RUST_VERSION)
envs_docker_rust__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)
envs_docker_rust__SQLX_VERSION = 0.7.1

docker_rust__ENVS = $(foreach VAR,$(filter envs_docker_rust__%,$(.VARIABLES)),$(subst envs_docker_rust__,,$(VAR)))

docker_rust__BUILD_ARGS = BASE_IMAGE RUST_VERSION TARGET_ARCH SQLX_VERSION

CTXES := $(CTXES) docker_rust

########################################################################################################################
CTX := docker_bar
########################################################################################################################
ctx_docker_bar__ENABLED = yes
ctx_docker_bar__STAGE = docker

docker_bar__IN = $(MK)/docker.mk
docker_bar__OUT_DIR = $(OUT_DIR)/docker
docker_bar__OUT = $(docker_bar__OUT_DIR)/bar.mk

docker_bar__BRIDGE = $(DOCKER_NETWORK_NAME)
docker_bar__CONTAINER = builder_rust
docker_bar__CTX = $(PROJECT_ROOT)
docker_bar__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_bar__DRIVER = $(DOCKER_NETWORK_DRIVER)
docker_bar__ERR_IF_BRIDGE_EXISTS = yes
docker_bar__PUBLISH = 80:80/tcp
docker_bar__SUBNET = $(DOCKER_NETWORK_SUBNET)
docker_bar__TAG = latest

ifdef docker_bar__TAG
    docker_bar__IMAGE = bar:$(docker_bar__TAG)
else
    docker_bar__IMAGE = bar
endif

# docker build_args
envs_docker_bar__APP = bar
envs_docker_bar__BUILDER = $(docker_rust_IMAGE)
envs_docker_bar__BASE_IMAGE = $(DOCKER_ALPINE_IMAGE)
envs_docker_bar__BUILD_PROFILE = $(CARGO_PROFILE)
envs_docker_bar__BUILD_VERSION = $(BUILD_VERSION)
envs_docker_bar__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)

docker_bar__ENVS = $(foreach VAR,$(filter envs_docker_bar__%,$(.VARIABLES)),$(subst envs_docker_bar__,,$(VAR)))

docker_bar__BUILD_ARGS = APP BASE_IMAGE BUILD_PROFILE BUILD_VERSION TARGET_ARCH

CTXES := $(CTXES) docker_bar

########################################################################################################################
CTX := docker_foo
########################################################################################################################
ctx_docker_foo__ENABLED = yes
ctx_docker_foo__STAGE = docker

docker_foo__IN = $(MK)/docker.mk
docker_foo__OUT_DIR = $(OUT_DIR)/docker
docker_foo__OUT = $(docker_foo__OUT_DIR)/foo.mk

docker_foo__BRIDGE = $(DOCKER_NETWORK_NAME)
docker_foo__CONTAINER = builder_rust
docker_foo__CTX = $(PROJECT_ROOT)
docker_foo__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_foo__DRIVER = $(DOCKER_NETWORK_DRIVER)
docker_foo__ERR_IF_BRIDGE_EXISTS = yes
docker_foo__PUBLISH = 81:81/tcp
docker_foo__SUBNET = $(DOCKER_NETWORK_SUBNET)
docker_foo__TAG = latest

ifdef docker_foo__TAG
    docker_foo__IMAGE = foo:$(docker_foo__TAG)
else
    docker_foo__IMAGE = foo
endif

# docker build_args
envs_docker_foo__APP = foo
envs_docker_foo__BUILDER = $(docker_rust_IMAGE)
envs_docker_foo__BUILD_PROFILE = $(CARGO_PROFILE)
envs_docker_foo__BUILD_VERSION = $(BUILD_VERSION)
envs_docker_foo__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)
envs_docker_foo__BASE_IMAGE = $(DOCKER_ALPINE_IMAGE)

docker_foo__ENVS = $(foreach VAR,$(filter envs_docker_foo__%,$(.VARIABLES)),$(subst envs_docker_foo__,,$(VAR)))

docker_foo__BUILD_ARGS = APP BASE_IMAGE BUILD_PROFILE BUILD_VERSION TARGET_ARCH

CTXES := $(CTXES) docker_foo

########################################################################################################################
CTX := stand_yaml
########################################################################################################################
stand_yaml__IN = $(DOCKER_COMPOSE)/stand.yaml
stand_yaml__OUT_DIR = $(OUT_DIR)
stand_yaml__OUT = $(stand_yaml__OUT_DIR)/stand.yaml

# RUST
stand_yaml__RUST = rust
stand_yaml__RUST_BASE_IMAGE = $(envs_docker_rust__BASE_IMAGE) 
stand_yaml__RUST_CTX = $(docker_rust__CTX)
stand_yaml__RUST_DOCKERFILE = $(docker_rust__DOCKERFILE)
stand_yaml__RUST_IMAGE = $(docker_rust__IMAGE)
stand_yaml__RUST_VERSION = $(envs_docker_rust__RUST_VERSION) 
stand_yaml__SQLX_VERSION = $(envs_docker_rust__SQLX_VERSION)
stand_yaml__TARGET_ARCH = $(envs_docker_rust__TARGET_ARCH) 

# BAR
stand_yaml__BAR = bar
stand_yaml__BAR_BASE_IMAGE = $(envs_docker_bar__BASE_IMAGE)
stand_yaml__BAR_BRIDGE = $(stand_yaml__BRIDGE)
stand_yaml__BAR_BUILD_PROFILE = $(envs_docker_bar__BUILD_PROFILE)
stand_yaml__BAR_BUILD_VERSION = $(envs_docker_bar__BUILD_VERSION)
stand_yaml__BAR_BUILDER = $(stand_yaml__RUST_IMAGE)
stand_yaml__BAR_CTX = $(docker_bar__CTX)
stand_yaml__BAR_DOCKERFILE = $(docker_bar__DOCKERFILE)
stand_yaml__BAR_IMAGE = $(docker_bar__IMAGE)
stand_yaml__BAR_PUBLISH = $(docker_bar__PUBLISH)
stand_yaml__BAR_TARGET_ARCH = $(envs_docker_bar__TARGET_ARCH)

# FOO
stand_yaml__FOO = foo
stand_yaml__FOO_BASE_IMAGE = $(envs_docker_foo__BASE_IMAGE)
stand_yaml__FOO_BRIDGE = $(stand_yaml__BRIDGE)
stand_yaml__FOO_BUILD_PROFILE = $(envs_docker_foo__BUILD_PROFILE)
stand_yaml__FOO_BUILD_VERSION = $(envs_docker_foo__BUILD_VERSION)
stand_yaml__FOO_BUILDER = $(stand_yaml__RUST_IMAGE)
stand_yaml__FOO_CTX = $(docker_foo__CTX)
stand_yaml__FOO_DOCKERFILE = $(docker_foo__DOCKERFILE)
stand_yaml__FOO_IMAGE = $(docker_foo__IMAGE)
stand_yaml__FOO_PUBLISH = $(docker_foo__PUBLISH)
stand_yaml__FOO_TARGET_ARCH = $(envs_docker_foo__TARGET_ARCH)

# PG
stand_yaml__PG = pg
stand_yaml__PG_IMAGE = $(envs_docker_pg__BASE_IMAGE)
stand_yaml__PG_PUBLISH = $(docker_pg__PUBLISH)
stand_yaml__PG_BRIDGE = $(stand_yaml__BRIDGE)
# stand_yaml__PG_CTX = $(docker_pg__CTX)
# stand_yaml__PG_DOCKERFILE = $(docker_pg__DOCKERFILE)
# stand_yaml__PG_BASE_IMAGE = $(envs_docker_pg__BASE_IMAGE)

# REDIS
stand_yaml__REDIS = redis
stand_yaml__REDIS_ADMIN_PASSWORD = $(REDIS_ADMIN_PASSWORD)
stand_yaml__REDIS_IMAGE = $(envs_docker_redis__BASE_IMAGE)
stand_yaml__REDIS_PUBLISH = $(docker_redis__PUBLISH)
stand_yaml__REDIS_BRIDGE = $(stand_yaml__BRIDGE)
# stand_yaml__REDIS_CTX = $(docker_redis__CTX)
# stand_yaml__REDIS_DOCKERFILE = $(docker_redis__DOCKERFILE)
# stand_yaml__REDIS_BASE_IMAGE = $(envs_docker_redis__BASE_IMAGE)

# NETWORKS
stand_yaml__BRIDGE = stand
stand_yaml__DRIVER = $(DOCKER_NETWORK_DRIVER)
stand_yaml__NETWORK = 192.168.200.0/24

# PG_ENVS
envs_pg_stand_yaml__POSTGRES_PASSWORD = $(psql__ADMIN_PASSWORD)
envs_pg_stand_yaml__POSTGRES_DB = $(psql__ADMIN_DB)
envs_pg_stand_yaml__POSTGRES_USER = $(psql__ADMIN)
stand_yaml__PG_ENVS = $(foreach VAR,$(filter envs_pg_stand_yaml__%,$(.VARIABLES)),$(subst envs_pg_stand_yaml__,,$(VAR)))

# BAR_ENVS
envs_bar_stand_yaml__XX = 98765
envs_bar_stand_yaml__YYY = qwerty
stand_yaml__BAR_ENVS = $(foreach VAR,$(filter envs_bar_stand_yaml__%,$(.VARIABLES)),$(subst envs_bar_stand_yaml__,,$(VAR)))

# FOO_ENVS
envs_foo_stand_yaml__WWW = 98765
envs_foo_stand_yaml__YY = qwerty
stand_yaml__FOO_ENVS = $(foreach VAR,$(filter envs_foo_stand_yaml__%,$(.VARIABLES)),$(subst envs_foo_stand_yaml__,,$(VAR)))

$(foreach VAR,$(filter envs_pg_stand_yaml__%,$(.VARIABLES)), \
    $(eval envs_stand_yaml__$(subst envs_pg_stand_yaml__,,$(VAR)) = $($(VAR))) \
)

$(foreach VAR,$(filter envs_foo_stand_yaml__%,$(.VARIABLES)), \
    $(eval envs_stand_yaml__$(subst envs_foo_stand_yaml__,,$(VAR)) = $($(VAR))) \
)

$(foreach VAR,$(filter envs_bar_stand_yaml__%,$(.VARIABLES)), \
    $(eval envs_stand_yaml__$(subst envs_bar_stand_yaml__,,$(VAR)) = $($(VAR))) \
)

CTXES := $(CTXES) stand_yaml

# ########################################################################################################################
CTX := compose_stand_yaml
# ########################################################################################################################
compose_stand_yaml__IN = $(MK)/compose.mk
compose_stand_yaml__OUT_DIR = $(OUT_DIR)/compose
compose_stand_yaml__OUT = $(compose_stand_yaml__OUT_DIR)/stand.mk

compose_stand_yaml__DAEMONIZE ?= $(COMPOSE_DAEMONIZE)
compose_stand_yaml__FORCE_RECREATE ?= $(COMPOSE_FORCE_RECREATE)
compose_stand_yaml__NO_CACHE ?= $(COMPOSE_NO_CACHE)
compose_stand_yaml__PROJECT ?= xxx
compose_stand_yaml__PURGE_ON_BUILD ?= $(COMPOSE_PURGE_ON_BUILD)
compose_stand_yaml__RM_ALL ?= $(COMPOSE_RM_ALL)
compose_stand_yaml__RM_FORCE ?= $(COMPOSE_RM_FORCE)
compose_stand_yaml__RM_ON_UP ?= $(COMPOSE_RM_ON_UP)
compose_stand_yaml__RM_STOP ?= $(COMPOSE_RM_STOP)
compose_stand_yaml__RM_VOLUMES ?= $(COMPOSE_RM_VOLUMES)
compose_stand_yaml__TIMEOUT ?= $(COMPOSE_TIMEOUT)
compose_stand_yaml__YAML ?= $(stand_yaml__OUT)

CTXES := $(CTXES) compose_stand_yaml

########################################################################################################################
CTX := end
########################################################################################################################