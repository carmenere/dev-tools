DOCKERFILES = $(DEVTOOLS_DIR)/dockerfiles
TMPL_DIR = $(DEVTOOLS_DIR)/templates

include $(DEVTOOLS_DIR)/lib.mk

########################################################################################################################
# VARS
########################################################################################################################
OUTDIR = $(shell pwd)/.output
INSTALL_DIR = /usr/local/bin
PROJECT_ROOT = $(shell pwd)

# ENABLE/DISABLE globally
ENABLE_HOST = yes
ENABLE_DOCKER = no

#
DEFAULT_DB = example
DEFAULT_OS = ubuntu
DEFAULT_PASSWORD = 12345
DEFAULT_USER = fizzbuzz
EXIT_IF_DB_EXISTS = no
EXIT_IF_USER_EXISTS = no
FIXTURES_DIR = migrations/fixtures
LOCALHOST = localhost
SCHEMAS_DIR = migrations/schemas
SERVICE_CMD_PREFIX = brew services
SERVICES_DELAY = 5
STOP_ALL = no

# LOCAL
LOCALE_LANG = en_US.UTF-8
LOCALE_LC_ALL = en_US.UTF-8
LOCALE_LC_CTYPE = en_US.UTF-8

# C & C++ flags
CC := $(shell echo ${CC})
CPPFLAGS := $(shell echo ${CPPFLAGS})
CXX := $(shell echo ${CXX})
LDFLAGS := $(shell echo ${LDFLAGS})

# Common shell command
BASH = /usr/bin/env bash
BUILD_VERSION = $(shell git log -1 --format="%h")
PWD = $(shell pwd)
SH = /usr/bin/env sh

# sudo
SUDO_BIN = $(shell which sudo)
SUDO_USER = 

########################################################################################################################
# Order matters!
########################################################################################################################
# defaults
include $(DEVTOOLS_DIR)/defaults/*.mk

# toolchain
include $(DEVTOOLS_DIR)/toolchain/defaults.mk

# ctxes
include $(DEVTOOLS_DIR)/ctxes/*.mk
########################################################################################################################

# Render
RENDER = $(TPYTHON) -m render.main