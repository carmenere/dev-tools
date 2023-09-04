DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

$(foreach CTX,$(CTXES),$(eval $(CTX)__ENVS = $(call list_by_prefix,$(CTX)__env_)))
$(foreach CTX,$(CTXES),$(eval $(CTX)__BUILD_ARGS = $(call list_by_prefix,$(CTX)__arg_)))

RENDER ?= $(TPYTHON) -m render.main

.PHONY: all ctxes envs

# 1. Put CTX's envs to Render's envs.
all:
	$(foreach CTX,$(CTXES),cd $(DEVTOOLS_DIR) && \
		$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),$(subst $(CTX)__,,$(V))=$$'$(call escape,$($(V)))') \
		DEVTOOLS_DIR='$(DEVTOOLS_DIR)' SETTINGS='$(SETTINGS)' \
		$(RENDER) --in=$($(CTX)__IN) --out=$($(CTX)__OUT) \
	$(LF))

ctxes:
	@echo SETTINGS = $(SETTINGS)
	@$(foreach CTX,$(CTXES),echo "ctx_$(CTX)__ENABLED = $(ctx_$(CTX)__ENABLED); ctx_$(CTX)__STAGE = $(ctx_$(CTX)__STAGE)" $(LF))

envs:
	@echo SETTINGS = $(SETTINGS)
	@$(foreach CTX,$(CTXES),echo "$(CTX): enabled = $(ctx_$(CTX)__ENABLED); stage = $(ctx_$(CTX)__STAGE)" $(LF) \
	$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),echo "    $(subst $(CTX)__,,$(V))='$($(V))'" $(LF)))
