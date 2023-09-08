DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOOLCHAIN := $(DEVTOOLS_DIR)/toolchain
CONF = $(DEVTOOLS_DIR)/configure/configure.mk
STAGES = $(DEVTOOLS_DIR)/configure/stages.mk

WITH += --with-python-defaults

# If VARS is undefined $(shell realpath ) returns current directory (.)
ifdef VARS
SETTINGS = $(shell realpath $(VARS))
else
SETTINGS =
endif

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

export SETTINGS
export SEVERITY ?= info
export DRY_RUN ?= no

.PHONY: toolchain configure deps init start-services stop-services images build install uninstall schemas fixtures upgrade \
start-apps stop-apps tests reports clean-services docker-rm clean distclean kill ctxes envs stop-all

toolchain:
	cd $(TOOLCHAIN) && \
		./configure $(WITH) && \
		$(MAKE) -f Makefile init

configure:
	$(MAKE) -f $(CONF) all

deps:
	$(MAKE) -f $(STAGES) deps

stop-all:
	$(MAKE) -f $(STAGES) stop-all

init: configure
	$(MAKE) -f $(STAGES) stop-all deps venvs images start-services init-services

start-services:
	$(MAKE) -f $(STAGES) start-services

stop-services:
	$(MAKE) -f $(STAGES) stop-services

images: configure
	$(MAKE) -f $(STAGES) images

build:
	$(MAKE) -f $(STAGES) schemas build

install:
	$(MAKE) -f $(STAGES) install

uninstall:
	$(MAKE) -f $(STAGES) uninstall

schemas: stop-apps
	$(MAKE) -f $(STAGES) schemas

fixtures: stop-apps
	$(MAKE) -f $(STAGES) schemas build fixtures

upgrade: stop-apps
	$(MAKE) -f $(STAGES) schemas build fixtures upgrades

start-apps: stop-apps build
	$(MAKE) -f $(STAGES) fixtures upgrades tmux start-apps

stop-apps:
	$(MAKE) -f $(STAGES) stop-apps tmux-kill-server

tests: start
	$(MAKE) -f $(STAGES) tests

reports: tests
	$(MAKE) -f $(STAGES) reports

clean-services: stop-apps
	$(MAKE) -f $(STAGES) clean-services

docker-rm:
	$(MAKE) -f $(STAGES) docker-rm

clean: stop-apps
	$(MAKE) -f $(STAGES) clean docker-rm

distclean: stop-apps
	$(MAKE) -f $(STAGES) distclean docker-rm
	[ ! -d $(OUTDIR) ] || rm -rf $(OUTDIR)

kill:
	$(MAKE) -f $(STAGES) tmux-kill-server

ctxes:
	$(MAKE) -f $(CONF) ctxes

envs:
	$(MAKE) -f $(CONF) envs
