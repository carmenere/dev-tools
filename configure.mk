DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib

PROJECT_ROOT ?= $(TOPDIR)

# Default vars
include $(DEVTOOLS_DIR)/vars/defaults.mk $(DEVTOOLS_DIR)/vars/ctxes.mk $(LIB)/common.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

VENV_DIR ?= $(abspath .venv)

RENDER ?= $(VENV_DIR)/bin/python -m render.main
SHELL ?= $(shell which bash)

export OUT_DIR
export TMPL_DIR

STAGES += docker-build
STAGES += sysctl-start
STAGES += docker-run
STAGES += schemas-start
STAGES += build-build
STAGES += venv-init
STAGES += pip-requirements
STAGES += tmux-init
STAGES += apps-start

.PHONY: all python

init:
	@echo DEVTOOLS_DIR = $(DEVTOOLS_DIR)
	$(MAKE) -f $(DEVTOOLS_DIR)/python.mk all VENV_DIR=$(VENV_DIR)

# 1. Put CTX's envs to Render's envs.
# 2. Put CTX's vars to Render's cli args.
all: init
	@echo DEVTOOLS_DIR = $(DEVTOOLS_DIR)
	$(foreach CTX,$(CTXES),echo "### CTX=$(CTX) ###" && cd $(DEVTOOLS_DIR) && \
		$(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(subst envs_$(CTX)__,,$(VAR))=$$'$(call escape,$($(VAR)))')\
		$(RENDER) \
		$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),--$(subst $(CTX)__,,$(V))=$$'$(call escape,$($(V)))') \
	$(LF))
