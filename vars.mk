TMPL_DIR = $(DEVTOOLS_DIR)/templates
TOOLS = $(TMPL_DIR)/tools
DOCKERFILES = $(TMPL_DIR)/dockerfiles
DOCKER_COMPOSE = $(TMPL_DIR)/compose

########################################################################################################################
CTX := cargo_foo
########################################################################################################################
$(CTX)__IN = $(TOOLS)/cargo.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/cargo/foo
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__BINS = foo
$(CTX)__CLIPPY_FORMAT = $(CARGO_CLIPPY_FORMAT)
$(CTX)__CLIPPY_REPORT = $(CARGO_CLIPPY_REPORT)
$(CTX)__FEATURES = $(CARGO_FEATURES)
$(CTX)__INSTALL_DIR = $(CARGO_INSTALL_DIR)
$(CTX)__LIB = $(LIB)
$(CTX)__LINTS = $(CARGO_LINTS)
$(CTX)__PROFILE = $(CARGO_PROFILE)
$(CTX)__TARGET_ARCH = $(RUST_TARGET_ARCH)
$(CTX)__TARGET_DIR = $(CARGO_TARGET_DIR)
$(CTX)__TOML = $(CARGO_TOML)
$(CTX)__TOPDIR = $(PWD)

ifeq ($($(CTX)__PROFILE),dev)
	$(CTX)__PROFILE_DIR = debug
else
	$(CTX)__PROFILE_DIR = $(PROFILE)
endif

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
cargo_foo__BINS_DIR = $(abspath $(cargo_foo__TARGET_DIR))/$(cargo_foo__TARGET_ARCH)/$(cargo_foo__PROFILE_DIR)

# cargo envs
envs_$(CTX)__RUSTFLAGS = $(RUSTFLAGS)
envs_$(CTX)__BUILD_VERSION = $(BUILD_VERSION)

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := cargo_bar
########################################################################################################################
$(CTX)__IN = $(TOOLS)/cargo.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/cargo/bar
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__BINS = bar
$(CTX)__CLIPPY_FORMAT = $(CARGO_CLIPPY_FORMAT)
$(CTX)__CLIPPY_REPORT = $(CARGO_CLIPPY_REPORT)
$(CTX)__FEATURES = $(CARGO_FEATURES)
$(CTX)__INSTALL_DIR = $(CARGO_INSTALL_DIR)
$(CTX)__LIB = $(LIB)
$(CTX)__LINTS = $(CARGO_LINTS)
$(CTX)__PROFILE = $(CARGO_PROFILE)
$(CTX)__TARGET_ARCH = $(RUST_TARGET_ARCH)
$(CTX)__TARGET_DIR = $(CARGO_TARGET_DIR)
$(CTX)__TOML = $(CARGO_TOML)
$(CTX)__TOPDIR = $(PWD)

ifeq ($($(CTX)__PROFILE),dev)
	$(CTX)__PROFILE_DIR = debug
else
	$(CTX)__PROFILE_DIR = $(PROFILE)
endif

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
cargo_bar__BINS_DIR = $(abspath $(cargo_bar__TARGET_DIR))/$(cargo_bar__TARGET_ARCH)/$(cargo_bar__PROFILE_DIR)

# cargo envs

# $(foreach VAR,$(filter envs_cargo_foo__%,$(.VARIABLES)),\
# 	$(eval envs_$(CTX)__$(lastword $(subst envs_cargo_foo__,,$(VAR))) = $($(VAR))) \
# )

envs_$(CTX)__RUSTFLAGS = $(RUSTFLAGS)
envs_$(CTX)__BUILD_VERSION = $(BUILD_VERSION)
envs_$(CTX)__DATABASE_URL = $(DATABASE_URL)

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := postgresql
########################################################################################################################
$(CTX)__IN = $(TOOLS)/postgresql.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/postgresql
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__AUTH_POLICY = host  all  all  $(REMOTE_PREFIX)  md5
$(CTX)__MAJOR = 12
$(CTX)__MINOR = 15_2
$(CTX)__OS = ubuntu
$(CTX)__OS_CODENAME = $$(lsb_release -cs)
$(CTX)__PG_HBA = /etc/postgresql/$(MAJOR)/main/pg_hba.conf
$(CTX)__REMOTE_PREFIX = 0.0.0.0/0
$(CTX)__SUDO_BIN = $(SUDO)
$(CTX)__SUDO_USER =
$(CTX)__TOPDIR = $(PWD)
$(CTX)__VERSION = $($(CTX)__MAJOR).$($(CTX)__MINOR)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := pg_ctl
########################################################################################################################
$(CTX)__IN = $(TOOLS)/pg_ctl.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/pg_ctl
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__ADMIN = $(PG_ADMIN)
$(CTX)__ADMIN_DB = $(PG_ADMIN_DB)
$(CTX)__ADMIN_PASSWORD = $(PG_ADMIN_PASSWORD)
$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__DATADIR = $($(CTX)__ARTEFACTS_DIR)/pg_data
$(CTX)__HOST = $(LOCALHOST)
$(CTX)__INITDB_AUTH_HOST = md5
$(CTX)__INITDB_AUTH_LOCAL = peer
$(CTX)__INITDB_PWFILE = /tmp/passwd.tmp
$(CTX)__LANG = $(LOCALE_LANG)
$(CTX)__LC_ALL = $(LOCALE_LC_ALL)
$(CTX)__LC_CTYPE = $(LOCALE_LC_CTYPE)
$(CTX)__OS_USER = $(PG_ADMIN)
$(CTX)__PG_CONFIG = $$(which pg_config)
$(CTX)__PG_CTL_CONF = $($(CTX)__DATADIR)/postgresql.conf
$(CTX)__PG_CTL_LOG = $($(CTX)__DATADIR)/pg_ctl.log
$(CTX)__PG_CTL_LOGGING_COLLECTOR = on
$(CTX)__PORT = $(PG_PORT)
$(CTX)__SUDO_BIN = $(SUDO)
$(CTX)__SUDO_USER = $(PG_ADMIN)
$(CTX)__TOPDIR = $(PWD)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := psql
########################################################################################################################
$(CTX)__IN = $(TOOLS)/psql.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/psql
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__AUTH_METHOD = remote
$(CTX)__CONTAINER =
$(CTX)__HOST = $(LOCALHOST)
$(CTX)__MODE = $(MODE)
$(CTX)__PGDATABASE = $(PG_ADMIN_DB)
$(CTX)__PGPASSWORD = $(PG_ADMIN_PASSWORD)
$(CTX)__PGUSER = $(PG_ADMIN)
$(CTX)__PORT = $(PG_PORT)
$(CTX)__SUDO_BIN = $(SUDO)
$(CTX)__SUDO_USER =
$(CTX)__TOPDIR = $(PWD)
$(CTX)__USER_ATTRIBUTES = SUPERUSER CREATEDB
$(CTX)__USER_DB = $(SERVICE_USER)
$(CTX)__USER_NAME = $(SERVICE_USER)
$(CTX)__USER_PASSWORD = $(SERVICE_PASSWORD)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := redis
########################################################################################################################
$(CTX)__IN = $(TOOLS)/redis-cli.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/redis
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__ADMIN = $(REDIS_ADMIN)
$(CTX)__ADMIN_DB = $(REDIS_ADMIN_DB)
$(CTX)__ADMIN_PASSWORD = $(REDIS_ADMIN_PASSWORD)
$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__CONTAINER =
$(CTX)__HOST = $(LOCALHOST)
$(CTX)__MODE = $(MODE)
$(CTX)__PORT = $(REDIS_PORT)
$(CTX)__REQUIREPASS = yes
$(CTX)__TOPDIR = $(PWD)
$(CTX)__USER_DB = $(SERVICE_USER)
$(CTX)__USER_NAME = $(SERVICE_USER)
$(CTX)__USER_PASSWORD = $(SERVICE_PASSWORD)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := venv_pytest
########################################################################################################################
$(CTX)__IN = $(TOOLS)/venv.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/venv
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__REQUIREMENTS = $(PROJECT_ROOT)/tests/requirements.txt
$(CTX)__VENV_DIR = $($(CTX)__OUT_DIR)/.venv
$(CTX)__CC = $(CC)
$(CTX)__CPPFLAGS = $(CPPFLAGS)
$(CTX)__CXX = $(CXX)
$(CTX)__LDFLAGS = $(LDFLAGS)
$(CTX)__PYTHON = $(PYTHON3)
$(CTX)__TOPDIR = $(PWD)
$(CTX)__VENV_PROMT = [VENV]
$(CTX)__VPYTHON = $(venv_pytest__VENV_DIR)/bin/python

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := python
########################################################################################################################
$(CTX)__IN = $(TOOLS)/python.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/python
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__DOWNLOAD_URL = https://www.python.org/ftp/python/$($(CTX)__VERSION)/Python-$($(CTX)__VERSION).tgz 
$(CTX)__MAJOR = 3.11
$(CTX)__MINOR = 4
$(CTX)__PIP = $($(CTX)__PYTHON) -m pip
$(CTX)__PREFIX =
$(CTX)__PYTHON = $$(shell which python$($(CTX)__MAJOR))
$(CTX)__TOPDIR = $(PWD)
$(CTX)__VERSION = $($(CTX)__MAJOR).$($(CTX)__MINOR)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := rustup
########################################################################################################################
$(CTX)__IN = $(TOOLS)/rustup.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/rustup
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__RUST_VERSION = $(RUST_VERSION)
$(CTX)__RUSTFLAGS = $(RUSTFLAGS)
$(CTX)__SQLX_VERSION = 0.7.1
$(CTX)__TARGET_ARCH = $(RUST_TARGET_ARCH)
$(CTX)__TOPDIR = $(PWD)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := app_sqlx_bar
########################################################################################################################
$(CTX)__IN = $(TOOLS)/app.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/apps/bar
$(CTX)__OUT = $($(CTX)__OUT_DIR)/sqlx.mk

$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.sqlx-artefacts
$(CTX)__BIN_PATH = sqlx migrate run
$(CTX)__LOG_FILE = $($(CTX)__ARTEFACTS_DIR)/logs.txt
$(CTX)__OPTS = --source "$(PROJECT_ROOT)/apps/bar/$(SCHEMAS_DIR)"
$(CTX)__PID_FILE = $($(CTX)__ARTEFACTS_DIR)/.pid
$(CTX)__PKILL_PATTERN =
$(CTX)__TOPDIR = $(PWD)

# sqlx envs
envs_$(CTX)__DATABASE_URL = $(DATABASE_URL)

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := app_foo
########################################################################################################################
$(CTX)__IN = $(TOOLS)/app.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/apps/foo
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__BIN_PATH = $(cargo_foo__BINS_DIR)/foo
$(CTX)__ENVS =
$(CTX)__LOG_FILE = $($(CTX)__ARTEFACTS_DIR)/logs.txt
$(CTX)__OPTS =
$(CTX)__PID_FILE = $($(CTX)__ARTEFACTS_DIR)/.pid
$(CTX)__PKILL_PATTERN = $($(CTX)__BIN_PATH)
$(CTX)__TOPDIR = $(PWD)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := app_bar
########################################################################################################################
$(CTX)__IN = $(TOOLS)/app.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/apps/bar
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__BIN_PATH = $(cargo_bar__BINS_DIR)/bar
$(CTX)__ENVS =
$(CTX)__LOG_FILE = $($(CTX)__ARTEFACTS_DIR)/logs.txt
$(CTX)__OPTS =
$(CTX)__PID_FILE = $($(CTX)__ARTEFACTS_DIR)/.pid
$(CTX)__PKILL_PATTERN = $($(CTX)__BIN_PATH)
$(CTX)__TOPDIR = $(PWD)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := pytest
########################################################################################################################
$(CTX)__IN = $(TOOLS)/pytest.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/pytest
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__TOPDIR = $(PWD)
$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__ENVS =
$(CTX)__LOG_FILE = $($(CTX)__ARTEFACTS_DIR)/logs.txt
$(CTX)__REPORTS_DIR = $($(CTX)__ARTEFACTS_DIR)/.reports
$(CTX)__TEST_CASES =
$(CTX)__TEST_CASES_DIR = $(PROJECT_ROOT)/tests
$(CTX)__VPYTHON = $(venv_pytest__VPYTHON)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := tmux
########################################################################################################################
$(CTX)__IN = $(TOOLS)/tmux.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/tmux
$(CTX)__OUT = $($(CTX)__OUT_DIR)/Makefile

$(CTX)__ARTEFACTS_DIR = $($(CTX)__OUT_DIR)/.artefacts
$(CTX)__DEFAULT_CMD = $(SH)
$(CTX)__DEFAULT_TERM = xterm-256color
$(CTX)__HISTORY_LIMIT = 1000000
$(CTX)__LOGS_DIR = $($(CTX)__ARTEFACTS_DIR)
$(CTX)__SESSION_NAME = DEV-TOOLS
$(CTX)__TERM_SIZE = 240x32
$(CTX)__TOPDIR = $(PWD)

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := docker_pg
########################################################################################################################
$(CTX)__IN = $(TOOLS)/docker.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/docker
$(CTX)__OUT = $($(CTX)__OUT_DIR)/pg.mk

$(CTX)__BRIDGE = $(DOCKER_NETWORK_NAME)
$(CTX)__CONTAINER = db
$(CTX)__CTX = $(PROJECT_ROOT)
$(CTX)__DOCKERFILE =
$(CTX)__DRIVER = $(DOCKER_NETWORK_DRIVER)
$(CTX)__ERR_IF_BRIDGE_EXISTS = yes
$(CTX)__PUBLISH = $(PG_PORT):$(PG_PORT)/tcp
$(CTX)__SUBNET = $(DOCKER_NETWORK_SUBNET)
$(CTX)__TAG = latest
$(CTX)__TOPDIR = $(PWD)

ifdef docker_pg__TAG
    $(CTX)__IMAGE = pg:$(docker_pg__TAG)
else
    $(CTX)__IMAGE = pg
endif

# docker build_args
envs_$(CTX)__BASE_IMAGE = $(DOCKER_PG_IMAGE)

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

$(CTX)__BUILD_ARGS = BASE_IMAGE

CTXES := $(CTXES) $(CTX)

# ########################################################################################################################
CTX := docker_redis
# ########################################################################################################################
$(CTX)__IN = $(TOOLS)/docker.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/docker
$(CTX)__OUT = $($(CTX)__OUT_DIR)/redis.mk

$(CTX)__BRIDGE = $(DOCKER_NETWORK_NAME)
$(CTX)__CONTAINER = redis
$(CTX)__CTX = $(PROJECT_ROOT)
$(CTX)__DOCKERFILE =
$(CTX)__DRIVER = $(DOCKER_NETWORK_DRIVER)
$(CTX)__ERR_IF_BRIDGE_EXISTS = yes
$(CTX)__PUBLISH = $(REDIS_PORT):$(REDIS_PORT)/tcp
$(CTX)__SUBNET = $(DOCKER_NETWORK_SUBNET)
$(CTX)__TAG = latest
$(CTX)__TOPDIR = $(PWD)

ifdef docker_redis__TAG
    $(CTX)__IMAGE = redis:$(docker_redis__TAG)
else
    $(CTX)__IMAGE = redis
endif

# docker build_args
envs_$(CTX)__BASE_IMAGE = $(DOCKER_REDIS_IMAGE)

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

$(CTX)__BUILD_ARGS = BASE_IMAGE

CTXES := $(CTXES) $(CTX)

# ########################################################################################################################
CTX := docker_rust
# ########################################################################################################################
$(CTX)__IN = $(TOOLS)/docker.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/docker
$(CTX)__OUT = $($(CTX)__OUT_DIR)/rust.mk

$(CTX)__BRIDGE = $(DOCKER_NETWORK_NAME)
$(CTX)__CONTAINER = builder_rust
$(CTX)__CTX = $(PROJECT_ROOT)
$(CTX)__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust
$(CTX)__DRIVER = $(DOCKER_NETWORK_DRIVER)
$(CTX)__ERR_IF_BRIDGE_EXISTS = yes
$(CTX)__PUBLISH =
$(CTX)__SUBNET = $(DOCKER_NETWORK_SUBNET)
$(CTX)__TAG = latest
$(CTX)__TOPDIR = $(PWD)

ifdef docker_rust__TAG
    $(CTX)__IMAGE = rust:$(docker_rust__TAG)
else
    $(CTX)__IMAGE = rust
endif

# docker build_args
envs_$(CTX)__BASE_IMAGE = $(DOCKER_ALPINE_IMAGE)
envs_$(CTX)__RUST_VERSION = $(DOCKER_RUST_VERSION)
envs_$(CTX)__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)
SQLX_VERSION = 0.7.1

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

$(CTX)__BUILD_ARGS = BASE_IMAGE RUST_VERSION TARGET_ARCH

CTXES := $(CTXES) $(CTX)

# ########################################################################################################################
CTX := docker_bar
# ########################################################################################################################
$(CTX)__IN = $(TOOLS)/docker.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/docker
$(CTX)__OUT = $($(CTX)__OUT_DIR)/bar.mk

$(CTX)__BRIDGE = $(DOCKER_NETWORK_NAME)
$(CTX)__CONTAINER = builder_rust
$(CTX)__CTX = $(PROJECT_ROOT)
$(CTX)__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
$(CTX)__DRIVER = $(DOCKER_NETWORK_DRIVER)
$(CTX)__ERR_IF_BRIDGE_EXISTS = yes
$(CTX)__PUBLISH = 80:80/tcp
$(CTX)__SUBNET = $(DOCKER_NETWORK_SUBNET)
$(CTX)__TAG = latest
$(CTX)__TOPDIR = $(PWD)

ifdef docker_bar__TAG
    $(CTX)__IMAGE = bar:$(docker_bar__TAG)
else
    $(CTX)__IMAGE = bar
endif

# docker build_args
envs_$(CTX)__APP = bar
envs_$(CTX)__BASE_IMAGE = $(docker_rust_IMAGE)
envs_$(CTX)__BUILD_PROFILE = $(CARGO_PROFILE)
envs_$(CTX)__BUILD_VERSION = $(BUILD_VERSION)
envs_$(CTX)__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

$(CTX)__BUILD_ARGS = APP BASE_IMAGE BUILD_PROFILE BUILD_VERSION TARGET_ARCH

CTXES := $(CTXES) $(CTX)

# ########################################################################################################################
CTX := docker_foo
# ########################################################################################################################
$(CTX)__IN = $(TOOLS)/docker.mk
$(CTX)__OUT_DIR = $(OUT_DIR)/docker
$(CTX)__OUT = $($(CTX)__OUT_DIR)/foo.mk

$(CTX)__BRIDGE = $(DOCKER_NETWORK_NAME)
$(CTX)__CONTAINER = builder_rust
$(CTX)__CTX = $(PROJECT_ROOT)
$(CTX)__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
$(CTX)__DRIVER = $(DOCKER_NETWORK_DRIVER)
$(CTX)__ERR_IF_BRIDGE_EXISTS = yes
$(CTX)__PUBLISH = 81:81/tcp
$(CTX)__SUBNET = $(DOCKER_NETWORK_SUBNET)
$(CTX)__TAG = latest
$(CTX)__TOPDIR = $(PWD)

ifdef docker_foo__TAG
    $(CTX)__IMAGE = foo:$(docker_foo__TAG)
else
    $(CTX)__IMAGE = foo
endif

# docker build_args
envs_$(CTX)__APP = foo
envs_$(CTX)__BASE_IMAGE = $(docker_rust_IMAGE)
envs_$(CTX)__BUILD_PROFILE = $(CARGO_PROFILE)
envs_$(CTX)__BUILD_VERSION = $(BUILD_VERSION)
envs_$(CTX)__TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)

$(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

$(CTX)__BUILD_ARGS = APP BASE_IMAGE BUILD_PROFILE BUILD_VERSION TARGET_ARCH

CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := stand_yaml
########################################################################################################################
$(CTX)__IN = $(DOCKER_COMPOSE)/stand.yaml
$(CTX)__OUT_DIR = $(OUT_DIR)
$(CTX)__OUT = $($(CTX)__OUT_DIR)/stand.yaml

$(CTX)__BAR = bar
$(CTX)__BAR_IMAGE = $(docker_bar__IMAGE)
$(CTX)__BAR_PUBLISH = $(docker_bar__PUBLISH)
$(CTX)__BRIDGE = stand
$(CTX)__FOO = foo
$(CTX)__FOO_IMAGE = $(docker_foo__IMAGE)
$(CTX)__FOO_PUBLISH = $(docker_foo__PUBLISH)
$(CTX)__PG = pg
$(CTX)__PG_IMAGE = $(DOCKER_PG_IMAGE)
$(CTX)__PG_PUBLISH = $(docker_pg__PUBLISH)
$(CTX)__REDIS = redis
$(CTX)__REDIS_ADMIN_PASSWORD = $(REDIS_ADMIN_PASSWORD)
$(CTX)__REDIS_IMAGE = $(DOCKER_REDIS_IMAGE)
$(CTX)__REDIS_PUBLISH = $(docker_redis__PUBLISH)

$(CTX)__BRIDGE = stand
$(CTX)__DRIVER = $(DOCKER_NETWORK_DRIVER)
$(CTX)__NETWORK = 192.168.200.0/24

# ENVS
envs_$(CTX)__XXX = redis

# $(CTX)__ENVS = $(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR))))

$(CTX)__REDIS_ENVS = XXX

# $(CTX)__BAR_ENVS =
# $(CTX)__FOO_ENVS = 
# $(CTX)__PG_ENVS =


CTXES := $(CTXES) $(CTX)

########################################################################################################################
CTX := end
########################################################################################################################