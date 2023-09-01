DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOOLCHAIN := $(DEVTOOLS_DIR)/toolchain
CONF = $(DEVTOOLS_DIR)/configure/configure.mk
STAGES = $(DEVTOOLS_DIR)/configure/stages.mk

WITH ?= --with-python-defaults

# If VARS is undefined $(shell realpath ) returns current directory (.)
ifdef VARS
SETTINGS = $(shell realpath $(VARS))
else
SETTINGS =
endif

export SEVERITY ?= info
export DRY_RUN ?= no

.PHONY: toolchain configure deps init build schemas upgrade stop start stop-services tests reports clean-services \
clean distclean kill ctxes

toolchain:
	cd $(TOOLCHAIN) && \
		./configure $(WITH) && \
		$(MAKE) -f Makefile init

configure:
	make -f $(CONF) all SETTINGS=$(SETTINGS)

init: configure
	make -f $(STAGES) deps venvs stop-disabled services init

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

tests: start
	make -f $(STAGES) tests

reports: tests
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
