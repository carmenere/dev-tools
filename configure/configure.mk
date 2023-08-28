DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/..
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib
PROJECT_ROOT ?= $(TOPDIR)

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk 
include $(DEVTOOLS_DIR)/configure/ctxes.mk
include $(LIB)/common.mk

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

.PHONY: all python

# 1. Put CTX's envs to Render's envs.
# 2. Put CTX's vars to Render's cli args.
all:
	$(foreach CTX,$(CTXES),cd $(DEVTOOLS_DIR) && \
		$(foreach P,$(enrich_envs_$(CTX)),\
			$(foreach VAR,$(filter $(P)__%,$(.VARIABLES)), \
				$(eval envs_$(CTX)__$(subst $(P)__,,$(VAR)) = $($(VAR))) \
			) \
		) \
		$(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(subst envs_$(CTX)__,,$(VAR))=$$'$(call escape,$($(VAR)))')\
		$(RENDER) \
		$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),--$(subst $(CTX)__,,$(V))=$$'$(call escape,$($(V)))') \
	$(LF))
