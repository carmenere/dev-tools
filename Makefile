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

export SETTINGS
export SEVERITY ?= info
export DRY_RUN ?= no

.PHONY: toolchain configure deps init stop-disabled build schemas upgrade stop start stop-services tests reports clean-services \
clean distclean kill ctxes

toolchain:
	cd $(TOOLCHAIN) && \
		./configure $(WITH) && \
		$(MAKE) -f Makefile init

configure:
	make -f $(CONF) all

deps:
	make -f $(STAGES) deps

init: configure
	make -f $(STAGES) deps venvs stop-apps stop-disabled stop-services docker-rm images services init

stop-disabled:
	make -f $(STAGES) stop-disabled

start-services:
	make -f $(STAGES) services

build:
	make -f $(STAGES) schemas build

schemas: stop-apps
	make -f $(STAGES) schemas

upgrade: stop-apps
	make -f $(STAGES) schemas build fixtures upgrade

stop-apps:
	make -f $(STAGES) stop-apps
	make -f $(STAGES) tmux-kill-server

start: stop-apps build
	make -f $(STAGES) fixtures upgrade tmux apps

stop-services:
	make -f $(STAGES) stop-services

tests: start
	make -f $(STAGES) tests

reports: tests
	make -f $(STAGES) reports

clean-services: stop-apps
	make -f $(STAGES) clean-services

docker-rm:
	make -f $(STAGES) docker-rm

clean: stop-apps
	make -f $(STAGES) clean

distclean: stop-apps
	make -f $(STAGES) distclean

kill:
	make -f $(STAGES) tmux-kill-server

ctxes:
	make -f $(CONF) ctxes

envs:
	make -f $(CONF) envs
