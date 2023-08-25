DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib
PROJECT_ROOT ?= $(TOPDIR)

# Default vars
include $(DEVTOOLS_DIR)/vars/defaults.mk 
include $(DEVTOOLS_DIR)/vars/ctxes.mk
include $(LIB)/common.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

$(foreach VAR,$(filter envs_pg_stand_yaml__%,$(.VARIABLES)), \
    $(eval envs_stand_yaml__$(subst envs_pg_stand_yaml__,,$(VAR)) = $($(VAR))) \
)

$(foreach VAR,$(filter envs_foo_stand_yaml__%,$(.VARIABLES)), \
    $(eval envs_stand_yaml__$(subst envs_foo_stand_yaml__,,$(VAR)) = $($(VAR))) \
)

$(foreach VAR,$(filter envs_bar_stand_yaml__%,$(.VARIABLES)), \
    $(eval envs_stand_yaml__$(subst envs_bar_stand_yaml__,,$(VAR)) = $($(VAR))) \
)

VENV_DIR ?= $(abspath .venv)
RENDER ?= $(VENV_DIR)/bin/python -m render.main
SHELL ?= $(shell which bash)

export OUT_DIR
export TMPL_DIR

.PHONY: all python

init:
	$(MAKE) -f $(DEVTOOLS_DIR)/python.mk all VENV_DIR=$(VENV_DIR)

# 1. Put CTX's envs to Render's envs.
# 2. Put CTX's vars to Render's cli args.
all: init
	$(foreach CTX,$(CTXES),echo "### CTX=$(CTX) ###" && cd $(DEVTOOLS_DIR) && \
		$(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(subst envs_$(CTX)__,,$(VAR))=$$'$(call escape,$($(VAR)))')\
		$(RENDER) \
		$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),--$(subst $(CTX)__,,$(V))=$$'$(call escape,$($(V)))') \
	$(LF))
