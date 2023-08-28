DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOOLCHAIN := $(DEVTOOLS_DIR)/toolchain
TOPDIR := $(shell pwd)

CONF = $(DEVTOOLS_DIR)/configure/configure.mk
STAGES = $(DEVTOOLS_DIR)/configure/stages.mk
VENV_DIR ?= $(abspath $(TOOLCHAIN)/.venv)

# If VARS is undefined $(shell realpath ) returns current directory (.)
ifdef VARS
SETTINGS = $(shell realpath $(VARS))
else
SETTINGS =
endif

export SETTINGS
export SEVERITY ?= info

.PHONY: init toolchain configure start tests reports

toolchain:
	cd $(TOOLCHAIN) && autoreconf -fi . && \
		./configure VENV_DIR=$(VENV_DIR) && \
		$(MAKE) -f Makefile init 

init : toolchain

configure:
	make -f $(CONF) all VENV_DIR=$(VENV_DIR) SEVERITY=$(SEVERITY)

start: configure
	make -f $(STAGES) start

tests: configure
	make -f $(STAGES) tests

reports: configure
	make -f $(STAGES) reports

distclean:
	cd $(TOOLCHAIN) && $(MAKE) -f Makefile distclean
