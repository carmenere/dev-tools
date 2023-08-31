DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/..

# Default vars
include $(DEVTOOLS_DIR)/configure/ctxes.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

TPYTHON ?= $(d__PYTHON)
RENDER ?= $(TPYTHON) -m render.main

.PHONY: all

# 1. Put CTX's envs to Render's envs.
all:
	$(foreach CTX,$(CTXES),cd $(DEVTOOLS_DIR) && \
		$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),$(subst $(CTX)__,,$(V))=$$'$(call escape,$($(V)))') \
		$(RENDER) --in=$($(CTX)__IN) --out=$($(CTX)__OUT) \
	$(LF))

