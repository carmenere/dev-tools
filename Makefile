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

export SEVERITY ?= info
export DRY_RUN ?= no

.PHONY: toolchain configure init upgrade stop start stop-services tests reports clean-services clean distclean

toolchain:
	cd $(TOOLCHAIN) && autoreconf -fi . && ./configure VENV_DIR=$(VENV_DIR) && $(MAKE) -f Makefile init 

configure:
	make -f $(CONF) all VENV_DIR=$(VENV_DIR) SETTINGS=$(SETTINGS)

init: configure
	make -f $(STAGES) extensions venvs stop-disabled services init

build: 
	make -f $(STAGES) schemas build

schemas: stop
	make -f $(STAGES) schemas

upgrade: stop
	make -f $(STAGES) schemas build fixtures upgrade

stop:
	make -f $(STAGES) stop
	make -f $(STAGES) tmux-kill-server

start: stop build
	make -f $(STAGES) fixtures upgrade tmux apps

stop-services:
	make -f $(STAGES) stop-services

tests:
	make -f $(STAGES) tests

reports:
	make -f $(STAGES) reports

clean-services: stop
	make -f $(STAGES) clean-services

clean: stop
	make -f $(STAGES) clean

distclean: stop
	make -f $(STAGES) distclean

kill:
	make -f $(STAGES) tmux-kill-server

ctxes:
	make -f $(STAGES) ctxes
