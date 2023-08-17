LIB := $(DEVTOOLS_DIR)/tools/lib
PWD := $(shell pwd)
RENDER := python3 -m render.main
SHELL := /bin/bash
DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# Default vars
include $(DEVTOOLS_DIR)/vars.mk

# Customized vars
ifdef VARS
	# Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
	include $(shell realpath $(VARS))
endif

export OUT_DIR
export TMPL_DIR

TARGETS = cargo \
			pg_ctl \
			postgresql \
			psql \
			python \
			redis-cli \
			venv

.PHONY: $(TARGETS) all

all: $(TARGETS)

debug:
	@echo VARS = $(VARS)
	@echo SETTINGS = $(SETTINGS)

cargo:
	cd $(DEVTOOLS_DIR) && $(RENDER) --in=$@.mk --out=$(CARGO_MAKE) \
		--LIB='$(LIB))' \
		--PROFILE='$(CARGO_PROFILE)' \
		--CARGO_TOML='$(CARGO_CARGO_TOML)' \
		--CLIPPY_FORMAT='$(CARGO_CLIPPY_FORMAT)' \
		--CLIPPY_REPORT='$(CARGO_CLIPPY_REPORT)' \
		--TARGET_ARCH='$(CARGO_TARGET_ARCH)' \
		--TARGET_DIR='$(CARGO_TARGET_DIR)' \
		--INSTALL_DIR='$(CARGO_INSTALL_DIR)' \
		--BINS='$(CARGO_BINS)' \
		--ENVS='$(CARGO_ENVS))' \
		--FEATURES='$(CARGO_FEATURES)' \
		--LINTS='$(CARGO_LINTS)'

pg_ctl:
	cd $(DEVTOOLS_DIR) && $(RENDER) --in=$@.mk --out=$(PG_CTL_MAKE) \
		--ADMIN='$(PG_CTL_ADMIN)' \
		--ADMIN_DB='$(PG_CTL_ADMIN_DB)' \
		--ADMIN_PASSWORD='$(PG_CTL_ADMIN_PASSWORD)' \
		--ARTEFACTS_DIR='$(PG_CTL_ARTEFACTS_DIR)' \
		--DATADIR='$(PG_CTL_DATADIR)' \
		--HOST='$(PG_CTL_HOST)' \
		--INITDB_AUTH_HOST='$(PG_CTL_INITDB_AUTH_HOST)' \
		--INITDB_AUTH_LOCAL='$(PG_CTL_INITDB_AUTH_LOCAL)' \
		--INITDB_PWFILE='$(PG_CTL_INITDB_PWFILE)' \
		--OS_USER='$(PG_CTL_OS_USER)' \
		--PG_CONFIG='$(PG_CTL_PG_CONFIG)' \
		--PG_CTL_CONF='$(PG_CTL_CONF)' \
		--PG_CTL_LOG='$(PG_CTL_LOG)' \
		--PG_CTL_LOGGING_COLLECTOR='$(PG_CTL_LOGGING_COLLECTOR)' \
		--PORT='$(PG_CTL_PORT)' \
		--LANG='$(PG_CTL_LANG)' \
		--LC_ALL='$(PG_CTL_LC_ALL)' \
		--LC_CTYPE='$(PG_CTL_LC_CTYPE)' \
		--SUDO_BIN='$(PG_CTL_SUDO_BIN)' \
		--SUDO_USER='$(PG_CTL_SUDO_USER)'

postgresql:
	cd $(DEVTOOLS_DIR) && $(RENDER) --in=$@.mk --out=$(POSTGRESQL_MAKE) \
		--MAJOR='$(POSTGRESQL_MAJOR)' \
		--MINOR='$(POSTGRESQL_MINOR)' \
		--VERSION='$(POSTGRESQL_VERSION)' \
		--OS='$(POSTGRESQL_OS)' \
		--OS_CODENAME='$(POSTGRESQL_OS_CODENAME)' \
		--REMOTE_PREFIX='$(POSTGRESQL_REMOTE_PREFIX)' \
		--AUTH_POLICY='$(POSTGRESQL_AUTH_POLICY)' \
		--PG_HBA='$(POSTGRESQL_PG_HBA)' \
		--SUDO_BIN='$(POSTGRESQL_SUDO_BIN)' \
		--SUDO_USER='$(POSTGRESQL_SUDO_USER)'

psql:
	cd $(DEVTOOLS_DIR) && $(RENDER) --in=$@.mk --out=$(PSQL_MAKE) \
		--ARTEFACTS_DIR='$(PSQL_ARTEFACTS_DIR)' \
		--AUTH_METHOD='$(PSQL_AUTH_METHOD)' \
		--HOST='$(PSQL_HOST)' \
		--PGDATABASE='$(PSQL_PGDATABASE)' \
		--PGPASSWORD='$(PSQL_PGPASSWORD)' \
		--PGUSER='$(PSQL_PGUSER)' \
		--PORT='$(PSQL_PORT)' \
		--USER_NAME='$(PSQL_USER_NAME)' \
		--USER_DB='$(PSQL_USER_DB)' \
		--USER_PASSWORD='$(PSQL_USER_PASSWORD)' \
		--USER_ATTRIBUTES='$(PSQL_USER_ATTRIBUTES)' \
		--CONTAINER='$(PSQL_CONTAINER)' \
		--MODE='$(PSQL_MODE)' \
		--SUDO_BIN='$(PSQL_SUDO_BIN)' \
		--SUDO_USER='$(PSQL_SUDO_USER)'

python:
	cd $(DEVTOOLS_DIR) && $(RENDER) --in=$@.mk --out=$(PY_MAKE) \
		--MAJOR='$(PY_MAJOR)' \
		--MINOR='$(PY_MINOR)' \
		--DOWNLOAD_URL='$(PY_DOWNLOAD_URL)' \
		--PYTHON='$(PY_PYTHON)'

redis-cli:
	cd $(DEVTOOLS_DIR) && $(RENDER) --in=$@.mk --out=$(REDIS_MAKE) \
		--ADMIN='$(REDIS_ADMIN)' \
		--ADMIN_DB='$(REDIS_ADMIN_DB)' \
		--ADMIN_PASSWORD='$(REDIS_ADMIN_PASSWORD)' \
		--ARTEFACTS_DIR='$(REDIS_ARTEFACTS_DIR)' \
		--HOST='$(REDIS_HOST)' \
		--PORT='$(REDIS_PORT)' \
		--REQUIREPASS='$(REDIS_REQUIREPASS)' \
		--USER_NAME='$(REDIS_USER_NAME)' \
		--USER_DB='$(REDIS_USER_DB)' \
		--USER_PASSWORD='$(REDIS_USER_PASSWORD)' \
		--CONTAINER='$(REDIS_CONTAINER)' \
		--MODE='$(REDIS_MODE)'

venv:
	cd $(DEVTOOLS_DIR) && $(RENDER) --in=$@.mk --out=$(VENV_MAKE) \
		--PYTHON='$(VENV_PYTHON)' \
		--VENV_PROMT='$(VENV_VENV_PROMT)' \
		--VENV_DIR='$(VENV_VENV_DIR)' \
		--VPYTHON='$(VENV_VPYTHON)' \
		--REQUIREMENTS='$(VENV_REQUIREMENTS)' \
		--CPPFLAGS='$(VENV_CPPFLAGS)' \
		--LDFLAGS='$(VENV_LDFLAGS)' \
		--CC='$(VENV_CC)' \
		--CXX='$(VENV_CXX)'
