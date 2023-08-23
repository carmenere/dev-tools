DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# TOPDIR := $(shell pwd)
RENDER := python3 -m render.main
SHELL := /bin/bash

TOPDIR := $(shell pwd)
LIB := $(DEVTOOLS_DIR)/lib

PROJECT_ROOT ?= $(TOPDIR)

# Default vars
include $(DEVTOOLS_DIR)/defaults.mk $(DEVTOOLS_DIR)/vars.mk $(LIB)/common.mk

# Customized vars
ifdef VARS
	# Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
	include $(shell realpath $(VARS))
endif

export OUT_DIR
export TMPL_DIR

.PHONY: all

# 1. Put CTX's envs to Render's envs.
# 2. Put CTX's vars to Render's cli args.
all:
	@echo cargo_foo__IN = $(cargo_foo__IN)
	@echo CTXES = $(CTXES)
	@echo VARIABLES = "$(.VARIABLES)"
	$(foreach CTX,$(CTXES),cd $(DEVTOOLS_DIR) && \
		$(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(lastword $(subst envs_$(CTX)__,,$(VAR)))=$$'$(call escape,$($(VAR)))')\
		$(RENDER) \
		$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),--$(lastword $(subst $(CTX)__,,$(V)))=$$'$(call escape,$($(V)))') \
	$(LF))
