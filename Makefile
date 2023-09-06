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

.PHONY: toolchain configure deps init stop-disabled start-services stop-services build schemas upgrade \
start-apps stop-apps tests reports clean-services docker-rm clean distclean kill ctxes envs stop-all

toolchain:
	cd $(TOOLCHAIN) && \
		./configure $(WITH) && \
		$(MAKE) -f Makefile init

configure:
	make -f $(CONF) all

deps:
	make -f $(STAGES) deps

stop-all:
	make -f $(STAGES) stop-disabled docker-rm-disabled stop-services stop-apps

init: configure stop-all
	make -f $(STAGES) deps venvs images start-services init-services

start-services:
	make -f $(STAGES) start-services

stop-services:
	make -f $(STAGES) stop-services

build:
	make -f $(STAGES) schemas build

install:
	make -f $(STAGES) install

uninstall:
	make -f $(STAGES) uninstall

schemas: stop-apps
	make -f $(STAGES) schemas

fixtures: stop-apps
	make -f $(STAGES) schemas build fixtures

upgrade: stop-apps
	make -f $(STAGES) schemas build fixtures upgrade

start-apps: stop-apps build
	make -f $(STAGES) fixtures upgrade tmux start-apps

stop-apps:
	make -f $(STAGES) stop-apps tmux-kill-server

stop-disabled:
	make -f $(STAGES) stop-disabled

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
