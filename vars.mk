TMPL_DIR = $(DEVTOOLS_DIR)/templates
MK = $(TMPL_DIR)/make
DOCKERFILES = $(TMPL_DIR)/dockerfiles
DOCKER_COMPOSE = $(TMPL_DIR)/compose

########################################################################################################################
CTX := cargo_foo
########################################################################################################################
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
cargo_foo__TOPDIR = $(PWD)

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

cargo_foo__ENVS = $(foreach VAR,$(filter envs_cargo_foo__%,$(.VARIABLES)),$(lastword $(subst envs_cargo_foo__,,$(VAR))))

CTXES := $(CTXES) cargo_foo

########################################################################################################################
CTX := cargo_bar
########################################################################################################################
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
cargo_bar__TOPDIR = $(PWD)

ifeq ($(cargo_bar__PROFILE),dev)
	cargo_bar__PROFILE_DIR = debug
else
	cargo_bar__PROFILE_DIR = $(PROFILE)
endif

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
cargo_bar__BINS_DIR = $(abspath $(cargo_bar__TARGET_DIR))/$(cargo_bar__TARGET_ARCH)/$(cargo_bar__PROFILE_DIR)

# cargo envs

$(foreach VAR,$(filter envs_cargo_foo__%,$(.VARIABLES)),\
	$(eval envs_cargo_bar__$(lastword $(subst envs_cargo_foo__,,$(VAR))) = $($(VAR))) \
)

envs_cargo_bar__RUSTFLAGS = $(RUSTFLAGS)
envs_cargo_bar__BUILD_VERSION = $(BUILD_VERSION)
envs_cargo_bar__DATABASE_URL = $(DATABASE_URL)

cargo_bar__ENVS = $(foreach VAR,$(filter envs_cargo_bar__%,$(.VARIABLES)),$(lastword $(subst envs_cargo_bar__,,$(VAR))))

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
postgresql__OS_CODENAME = $$(lsb_release -cs)
postgresql__PG_HBA = /etc/postgresql/$(MAJOR)/main/pg_hba.conf
postgresql__REMOTE_PREFIX = 0.0.0.0/0
postgresql__SUDO_BIN = $(SUDO)
postgresql__SUDO_USER =
postgresql__TOPDIR = $(PWD)
postgresql__VERSION = $(postgresql__MAJOR).$(postgresql__MINOR)

CTXES := $(CTXES) postgresql

########################################################################################################################
CTX := pg_ctl
########################################################################################################################
pg_ctl__IN = $(MK)/pg_ctl.mk
pg_ctl__OUT_DIR = $(OUT_DIR)/pg_ctl
pg_ctl__OUT = $(pg_ctl__OUT_DIR)/Makefile

pg_ctl__ADMIN = $(PG_ADMIN)
pg_ctl__ADMIN_DB = $(PG_ADMIN_DB)
pg_ctl__ADMIN_PASSWORD = $(PG_ADMIN_PASSWORD)
pg_ctl__ARTEFACTS_DIR = $(pg_ctl__OUT_DIR)/.artefacts
pg_ctl__DATADIR = $(pg_ctl__ARTEFACTS_DIR)/pg_data
pg_ctl__HOST = $(LOCALHOST)
pg_ctl__INITDB_AUTH_HOST = md5
pg_ctl__INITDB_AUTH_LOCAL = peer
pg_ctl__INITDB_PWFILE = /tmp/passwd.tmp
pg_ctl__LANG = $(LOCALE_LANG)
pg_ctl__LC_ALL = $(LOCALE_LC_ALL)
pg_ctl__LC_CTYPE = $(LOCALE_LC_CTYPE)
pg_ctl__OS_USER = $(PG_ADMIN)
pg_ctl__PG_CONFIG = $$(which pg_config)
pg_ctl__PG_CTL_CONF = $(pg_ctl__DATADIR)/postgresql.conf
pg_ctl__PG_CTL_LOG = $(pg_ctl__DATADIR)/pg_ctl.log
pg_ctl__PG_CTL_LOGGING_COLLECTOR = on
pg_ctl__PORT = $(PG_PORT)
pg_ctl__SUDO_BIN = $(SUDO)
pg_ctl__SUDO_USER = $(PG_ADMIN)
pg_ctl__TOPDIR = $(PWD)

CTXES := $(CTXES) pg_ctl

########################################################################################################################
CTX := psql
########################################################################################################################
psql__IN = $(MK)/psql.mk
psql__OUT_DIR = $(OUT_DIR)/psql
psql__OUT = $(psql__OUT_DIR)/Makefile

psql__ARTEFACTS_DIR = $(psql__OUT_DIR)/.artefacts
psql__AUTH_METHOD = remote
psql__CONTAINER =
psql__HOST = $(LOCALHOST)
psql__MODE = $(MODE)
psql__PGDATABASE = $(PG_ADMIN_DB)
psql__PGPASSWORD = $(PG_ADMIN_PASSWORD)
psql__PGUSER = $(PG_ADMIN)
psql__PORT = $(PG_PORT)
psql__SUDO_BIN = $(SUDO)
psql__SUDO_USER =
psql__TOPDIR = $(PWD)
psql__USER_ATTRIBUTES = SUPERUSER CREATEDB
psql__USER_DB = $(SERVICE_USER)
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
redis__TOPDIR = $(PWD)
redis__USER_DB = $(SERVICE_USER)
redis__USER_NAME = $(SERVICE_USER)
redis__USER_PASSWORD = $(SERVICE_PASSWORD)

CTXES := $(CTXES) redis

########################################################################################################################
CTX := venv_pytest
########################################################################################################################
venv_pytest__IN = $(MK)/venv.mk
venv_pytest__OUT_DIR = $(OUT_DIR)/venv
venv_pytest__OUT = $(venv_pytest__OUT_DIR)/Makefile

venv_pytest__REQUIREMENTS = $(PROJECT_ROOT)/tests/requirements.txt
venv_pytest__VENV_DIR = $(venv_pytest__OUT_DIR)/.venv
venv_pytest__CC = $(CC)
venv_pytest__CPPFLAGS = $(CPPFLAGS)
venv_pytest__CXX = $(CXX)
venv_pytest__LDFLAGS = $(LDFLAGS)
venv_pytest__PYTHON = $(PYTHON)
venv_pytest__TOPDIR = $(PWD)
venv_pytest__VENV_PROMT = [VENV]
venv_pytest__VPYTHON = $(venv_pytest__VENV_DIR)/bin/python

CTXES := $(CTXES) venv_pytest

########################################################################################################################
CTX := python
########################################################################################################################
python__IN = $(MK)/python.mk
python__OUT_DIR = $(OUT_DIR)/python
python__OUT = $(python__OUT_DIR)/Makefile

python__ARTEFACTS_DIR = $(python__OUT_DIR)/.artefacts
python__DOWNLOAD_URL = https://www.python.org/ftp/python/$(python__VERSION)/Python-$(python__VERSION).tgz 
python__MAJOR = 3.11
python__MINOR = 4
python__PIP = $(python__PYTHON) -m pip
python__PREFIX =
python__PYTHON = $$(shell which python$(python__MAJOR))
python__TOPDIR = $(PWD)
python__VERSION = $(python__MAJOR).$(python__MINOR)

CTXES := $(CTXES) python

########################################################################################################################
CTX := rustup
########################################################################################################################
rustup__IN = $(MK)/rustup.mk
rustup__OUT_DIR = $(OUT_DIR)/rustup
rustup__OUT = $(rustup__OUT_DIR)/Makefile

rustup__RUST_VERSION = $(RUST_VERSION)
rustup__RUSTFLAGS = $(RUSTFLAGS)
rustup__SQLX_VERSION = 0.7.1
rustup__TARGET_ARCH = $(RUST_TARGET_ARCH)
rustup__TOPDIR = $(PWD)

CTXES := $(CTXES) rustup

########################################################################################################################
CTX := app_sqlx_bar
########################################################################################################################
app_sqlx_bar__IN = $(MK)/app.mk
app_sqlx_bar__OUT_DIR = $(OUT_DIR)/apps/bar
app_sqlx_bar__OUT = $(app_sqlx_bar__OUT_DIR)/sqlx.mk

app_sqlx_bar__ARTEFACTS_DIR = $(app_sqlx_bar__OUT_DIR)/.sqlx-artefacts
app_sqlx_bar__BIN_PATH = sqlx migrate run
app_sqlx_bar__LOG_FILE = $(app_sqlx_bar__ARTEFACTS_DIR)/logs.txt
app_sqlx_bar__OPTS = --source "$(PROJECT_ROOT)/apps/bar/$(SCHEMAS_DIR)"
app_sqlx_bar__PID_FILE = $(app_sqlx_bar__ARTEFACTS_DIR)/.pid
app_sqlx_bar__PKILL_PATTERN =
app_sqlx_bar__TOPDIR = $(PWD)

# sqlx envs
envs_app_sqlx_bar__DATABASE_URL = $(DATABASE_URL)

app_sqlx_bar__ENVS = $(foreach VAR,$(filter envs_app_sqlx_bar__%,$(.VARIABLES)),$(lastword $(subst envs_app_sqlx_bar__,,$(VAR))))

CTXES := $(CTXES) app_sqlx_bar

########################################################################################################################
CTX := app_foo
########################################################################################################################
app_foo__IN = $(MK)/app.mk
app_foo__OUT_DIR = $(OUT_DIR)/apps/foo
app_foo__OUT = $(app_foo__OUT_DIR)/Makefile

app_foo__ARTEFACTS_DIR = $(app_foo__OUT_DIR)/.artefacts
app_foo__BIN_PATH = $(cargo_foo__BINS_DIR)/foo
app_foo__ENVS =
app_foo__LOG_FILE = $(app_foo__ARTEFACTS_DIR)/logs.txt
app_foo__OPTS =
app_foo__PID_FILE = $(app_foo__ARTEFACTS_DIR)/.pid
app_foo__PKILL_PATTERN = $(app_foo__BIN_PATH)
app_foo__TOPDIR = $(PWD)

CTXES := $(CTXES) app_foo

########################################################################################################################
CTX := app_bar
########################################################################################################################
app_bar__IN = $(MK)/app.mk
app_bar__OUT_DIR = $(OUT_DIR)/apps/bar
app_bar__OUT = $(app_bar__OUT_DIR)/Makefile

app_bar__ARTEFACTS_DIR = $(app_bar__OUT_DIR)/.artefacts
app_bar__BIN_PATH = $(cargo_bar__BINS_DIR)/bar
app_bar__ENVS =
app_bar__LOG_FILE = $(app_bar__ARTEFACTS_DIR)/logs.txt
app_bar__OPTS =
app_bar__PID_FILE = $(app_bar__ARTEFACTS_DIR)/.pid
app_bar__PKILL_PATTERN = $(app_bar__BIN_PATH)
app_bar__TOPDIR = $(PWD)

CTXES := $(CTXES) app_bar

########################################################################################################################
CTX := pytest
########################################################################################################################
pytest__IN = $(MK)/pytest.mk
pytest__OUT_DIR = $(OUT_DIR)/pytest
pytest__OUT = $(pytest__OUT_DIR)/Makefile

pytest__TOPDIR = $(PWD)
pytest__ARTEFACTS_DIR = $(pytest__OUT_DIR)/.artefacts
pytest__ENVS =
pytest__LOG_FILE = $(pytest__ARTEFACTS_DIR)/logs.txt
pytest__REPORTS_DIR = $(pytest__ARTEFACTS_DIR)/.reports
pytest__TEST_CASES =
pytest__TEST_CASES_DIR = $(PROJECT_ROOT)/tests
pytest__VPYTHON = $(venv_pytest__VPYTHON)

CTXES := $(CTXES) pytest

########################################################################################################################
CTX := tmux
########################################################################################################################
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
tmux__TOPDIR = $(PWD)

CTXES := $(CTXES) tmux

########################################################################################################################
CTX := docker_pg
########################################################################################################################
docker_pg__IN = $(MK)/docker.mk
docker_pg__OUT_DIR = $(OUT_DIR)/docker
docker_pg__OUT = $(docker_pg__OUT_DIR)/pg.mk

docker_pg__BRIDGE = $(DOCKER_NETWORK_NAME)
docker_pg__CONTAINER = db
docker_pg__CTX = $(PROJECT_ROOT)
docker_pg__DOCKERFILE =
docker_pg__DRIVER = $(DOCKER_NETWORK_DRIVER)
docker_pg__ERR_IF_BRIDGE_EXISTS = yes
docker_pg__PUBLISH = $(PG_PORT):$(PG_PORT)/tcp
docker_pg__SUBNET = $(DOCKER_NETWORK_SUBNET)
docker_pg__TAG = latest
docker_pg__TOPDIR = $(PWD)

ifdef docker_pg__TAG
    docker_pg__IMAGE = pg:$(docker_pg__TAG)
else
    docker_pg__IMAGE = pg
endif

# docker build_args
envs_docker_pg__BASE_IMAGE = $(DOCKER_PG_IMAGE)

docker_pg__ENVS = $(foreach VAR,$(filter envs_docker_pg__%,$(.VARIABLES)),$(lastword $(subst envs_docker_pg__,,$(VAR))))

docker_pg__BUILD_ARGS = BASE_IMAGE

CTXES := $(CTXES) docker_pg

# ########################################################################################################################
CTX := docker_redis
# ########################################################################################################################
docker_redis__IN = $(MK)/docker.mk
docker_redis__OUT_DIR = $(OUT_DIR)/docker
docker_redis__OUT = $(docker_redis__OUT_DIR)/redis.mk

docker_redis__BRIDGE = $(DOCKER_NETWORK_NAME)
docker_redis__CONTAINER = redis
docker_redis__CTX = $(PROJECT_ROOT)
docker_redis__DOCKERFILE =
docker_redis__DRIVER = $(DOCKER_NETWORK_DRIVER)
docker_redis__ERR_IF_BRIDGE_EXISTS = yes
docker_redis__PUBLISH = $(REDIS_PORT):$(REDIS_PORT)/tcp
docker_redis__SUBNET = $(DOCKER_NETWORK_SUBNET)
docker_redis__TAG = latest
docker_redis__TOPDIR = $(PWD)

ifdef docker_redis__TAG
    docker_redis__IMAGE = redis:$(docker_redis__TAG)
else
    docker_redis__IMAGE = redis
endif

# docker build_args
envs_docker_redis__BASE_IMAGE = $(DOCKER_REDIS_IMAGE)

docker_redis__ENVS = $(foreach VAR,$(filter envs_docker_redis__%,$(.VARIABLES)),$(lastword $(subst envs_docker_redis__,,$(VAR))))

docker_redis__BUILD_ARGS = BASE_IMAGE

CTXES := $(CTXES) docker_redis

# ########################################################################################################################
CTX := docker_rust
# ########################################################################################################################
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
docker_rust__TOPDIR = $(PWD)

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

docker_rust__ENVS = $(foreach VAR,$(filter envs_docker_rust__%,$(.VARIABLES)),$(lastword $(subst envs_docker_rust__,,$(VAR))))

docker_rust__BUILD_ARGS = BASE_IMAGE RUST_VERSION TARGET_ARCH SQLX_VERSION

CTXES := $(CTXES) docker_rust

# ########################################################################################################################
CTX := docker_bar
# ########################################################################################################################
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
docker_bar__TOPDIR = $(PWD)

ifdef docker_bar__TAG
    docker_bar__IMAGE = bar:$(docker_bar__TAG)
else
    docker_bar__IMAGE = bar
endif

# docker build_args
envs_docker_bar__APP = bar
envs_docker_bar__BASE_IMAGE = $(docker_rust_IMAGE)
envs_docker_bar__BUILD_PROFILE = $(CARGO_PROFILE)
envs_docker_bar__BUILD_VERSION = $(BUILD_VERSION)
envs_docker_bar__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)

docker_bar__ENVS = $(foreach VAR,$(filter envs_docker_bar__%,$(.VARIABLES)),$(lastword $(subst envs_docker_bar__,,$(VAR))))

docker_bar__BUILD_ARGS = APP BASE_IMAGE BUILD_PROFILE BUILD_VERSION TARGET_ARCH

CTXES := $(CTXES) docker_bar

# ########################################################################################################################
CTX := docker_foo
# ########################################################################################################################
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
docker_foo__TOPDIR = $(PWD)

ifdef docker_foo__TAG
    docker_foo__IMAGE = foo:$(docker_foo__TAG)
else
    docker_foo__IMAGE = foo
endif

# docker build_args
envs_docker_foo__APP = foo
envs_docker_foo__BASE_IMAGE = $(docker_rust_IMAGE)
envs_docker_foo__BUILD_PROFILE = $(CARGO_PROFILE)
envs_docker_foo__BUILD_VERSION = $(BUILD_VERSION)
envs_docker_foo__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)

docker_foo__ENVS = $(foreach VAR,$(filter envs_docker_foo__%,$(.VARIABLES)),$(lastword $(subst envs_docker_foo__,,$(VAR))))

docker_foo__BUILD_ARGS = APP BASE_IMAGE BUILD_PROFILE BUILD_VERSION TARGET_ARCH

CTXES := $(CTXES) docker_foo

########################################################################################################################
CTX := stand_yaml
########################################################################################################################
stand_yaml__IN = $(DOCKER_COMPOSE)/stand.yaml
stand_yaml__OUT_DIR = $(OUT_DIR)
stand_yaml__OUT = $(stand_yaml__OUT_DIR)/stand.yaml

stand_yaml__BAR = bar
stand_yaml__BAR_IMAGE = $(docker_bar__IMAGE)
stand_yaml__BAR_PUBLISH = $(docker_bar__PUBLISH)
stand_yaml__BRIDGE = stand
stand_yaml__FOO = foo
stand_yaml__FOO_IMAGE = $(docker_foo__IMAGE)
stand_yaml__FOO_PUBLISH = $(docker_foo__PUBLISH)
stand_yaml__PG = pg
stand_yaml__PG_IMAGE = $(DOCKER_PG_IMAGE)
stand_yaml__PG_PUBLISH = $(docker_pg__PUBLISH)
stand_yaml__REDIS = redis
stand_yaml__REDIS_ADMIN_PASSWORD = $(REDIS_ADMIN_PASSWORD)
stand_yaml__REDIS_IMAGE = $(DOCKER_REDIS_IMAGE)
stand_yaml__REDIS_PUBLISH = $(docker_redis__PUBLISH)

stand_yaml__BRIDGE = stand
stand_yaml__DRIVER = $(DOCKER_NETWORK_DRIVER)
stand_yaml__NETWORK = 192.168.200.0/24

# ENVS
envs_stand_yaml__XXX = redis

# stand_yaml__ENVS = $(foreach VAR,$(filter envs_stand_yaml__%,$(.VARIABLES)),$(lastword $(subst envs_stand_yaml__,,$(VAR))))

stand_yaml__REDIS_ENVS = XXX

# stand_yaml__BAR_ENVS =
# stand_yaml__FOO_ENVS = 
# stand_yaml__PG_ENVS =


CTXES := $(CTXES) stand_yaml

########################################################################################################################
CTX := end
########################################################################################################################