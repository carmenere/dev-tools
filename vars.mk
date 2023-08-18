include $(LIB)/common.mk

# COMMON
LOCALHOST = localhost
MIGRATIONS_DIR = migrations
SRV_DB = fizzbuzz
SRV_PASSWORD = 12345
SRV_USER = foobar

PROJECT_DIR = $(shell pwd)

OUT_DIR = $(PWD)/.output
TMPL_DIR = $(DEVTOOLS_DIR)/templates

DATABASE_URL = postgres://$(SRV_USER):$(SRV_PASSWORD)@$(PG_HOST):$(PG_PORT)/$(SRV_DB)
BUILD_VERSION = $(git describe --tags)

# TEMPLATES
TMPL_CARGO = $(TMPL_DIR)/tools/cargo.mk
TMPL_POSTGRESQL = $(TMPL_DIR)/tools/postgresql.mk
TMPL_PG_CTL = $(TMPL_DIR)/tools/pg_ctl.mk
TMPL_PSQL = $(TMPL_DIR)/tools/psql.mk
TMPL_REDIS = $(TMPL_DIR)/tools/redis-cli.mk
TMPL_VENV = $(TMPL_DIR)/tools/venv.mk
TMPL_PYTHON = $(TMPL_DIR)/tools/python.mk
TMPL_RUST = $(TMPL_DIR)/tools/rust.mk

# TEMPLATE: CARGO
CARGO|IN = $(TMPL_CARGO)
CARGO|OUT_DIR = $(OUT_DIR)/cargo
CARGO|OUT = $(CARGO|OUT_DIR)/Makefile
CARGO|ENVS = RUSTFLAGS=-C target-feature=-crt-static \
            BUILD_VERSION=$(BUILD_VERSION) \
            DATABASE_URL=$(DATABASE_URL)

# TEMPLATE: CARGO
MY_CARGO|IN = $(TMPL_CARGO)
MY_CARGO|OUT_DIR = $(OUT_DIR)/mycargo
MY_CARGO|OUT = $(MY_CARGO|OUT_DIR)/Makefile
MY_CARGO|ENVS = RUSTFLAGS=-C target-feature=-crt-static

# TEMPLATE: POSTGRESQL
POSTGRESQL|IN = $(TMPL_POSTGRESQL)
POSTGRESQL|OUT_DIR = $(OUT_DIR)/postgresql
POSTGRESQL|OUT = $(POSTGRESQL|OUT_DIR)/Makefile

# TEMPLATE: PG_CTL
PG_CTL|IN = $(TMPL_PG_CTL)
PG_CTL|OUT_DIR = $(OUT_DIR)/pg_ctl
PG_CTL|OUT = $(PG_CTL|OUT_DIR)/Makefile
PG_CTL|ARTEFACTS_DIR = $(PG_CTL|OUT_DIR)/.artefacts
PG_CTL|DATADIR = $(PG_CTL|OUT_DIR)/pg_data

# TEMPLATE: PSQL
PSQL|IN = $(TMPL_PSQL)
PSQL|OUT_DIR = $(OUT_DIR)/psql
PSQL|OUT = $(PSQL|OUT_DIR)/Makefile
PSQL|ARTEFACTS_DIR = $(PSQL|OUT_DIR)/.artefacts
PSQL|USER_NAME = $(SRV_USER)
PSQL|USER_DB = $(SRV_DB)
PSQL|USER_PASSWORD = $(SRV_PASSWORD)

# TEMPLATE: REDIS
REDIS|IN = $(TMPL_REDIS)
REDIS|OUT_DIR = $(OUT_DIR)/redis
REDIS|OUT = $(REDIS|OUT_DIR)/Makefile
REDIS|ARTEFACTS_DIR = $(REDIS|OUT_DIR)/.artefacts
REDIS|USER_NAME = $(SRV_USER)
REDIS|USER_DB = 0
REDIS|USER_PASSWORD = $(SRV_PASSWORD)

# TEMPLATE: VENV
VENV|IN = $(TMPL_VENV)
VENV|OUT_DIR = $(OUT_DIR)/venv
VENV|OUT = $(VENV|OUT_DIR)/Makefile
VENV|VENV_DIR = $(VENV|OUT_DIR)/.venv
VENV|REQUIREMENTS = $(DEVTOOLS_DIR)/render/requirements.txt

# TEMPLATE: PYTHON
PY|IN = $(TMPL_PYTHON)
PY|OUT_DIR = $(OUT_DIR)/python
PY|OUT = $(PY|OUT_DIR)/Makefile
PY|ARTEFACTS_DIR = $(PY|OUT_DIR)/.artefacts

# TEMPLATE: RUST
RUST|IN = $(TMPL_RUST)
RUST|OUT_DIR = $(OUT_DIR)/rust
RUST|OUT = $(RUST|OUT_DIR)/Makefile

# VARS per CTXES
CARGO = $(foreach V,$(filter CARGO|%,$(.VARIABLES)),$(V))
MY_CARGO = $(foreach V,$(filter MY_CARGO|%,$(.VARIABLES)),$(V))
PG_CTL = $(foreach V,$(filter PG_CTL|%,$(.VARIABLES)),$(V))
POSTGRESQL = $(foreach V,$(filter POSTGRESQL|%,$(.VARIABLES)),$(V))
PY = $(foreach V,$(filter PY|%,$(.VARIABLES)),$(V))
REDIS = $(foreach V,$(filter REDIS|%,$(.VARIABLES)),$(V))
VENV = $(foreach V,$(filter VENV|%,$(.VARIABLES)),$(V))
RUST = $(foreach V,$(filter RUST|%,$(.VARIABLES)),$(V))

# CTXES
CTXES += CARGO
CTXES += MY_CARGO
CTXES += PG_CTL
CTXES += POSTGRESQL
CTXES += PY
CTXES += REDIS
CTXES += VENV
CTXES += RUST
