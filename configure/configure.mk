DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

$(foreach CTX,$(CTXES),$(eval $(CTX)__OPTS = $(call list_by_prefix,$(CTX)__opt_)))
$(foreach CTX,$(CTXES),$(eval $(CTX)__ENVS = $(call list_by_prefix,$(CTX)__env_)))
$(foreach CTX,$(CTXES),$(eval $(CTX)__BUILD_ARGS = $(call list_by_prefix,$(CTX)__arg_)))

RENDER ?= $(TPYTHON) -m render.main

PATH_TO_DEFAULTS = $(OUTDIR)/.tmp/.defaults.env

.PHONY: all ctxes envs

# 1. Put CTX's envs to Render's envs.
defaults:
	[ ! -f $(PATH_TO_DEFAULTS) ] || rm -f $(PATH_TO_DEFAULTS)
	[ -d $(abspath $(dir $(PATH_TO_DEFAULTS))) ] || mkdir -p $(abspath $(dir $(PATH_TO_DEFAULTS)))
ifeq ($(SEVERITY),debug)
	$(foreach D,$(DEFAULTS),echo $(D)=$$'$(call escape,$($(D)))' >> $(PATH_TO_DEFAULTS) $(LF))
	echo DEFAULTS=$(DEFAULTS) >> $(PATH_TO_DEFAULTS)
	echo DEVTOOLS_DIR=$(DEVTOOLS_DIR) >> $(PATH_TO_DEFAULTS)
	echo SETTINGS=$(SETTINGS) >> $(PATH_TO_DEFAULTS)
else
	@$(foreach D,$(DEFAULTS),echo $(D)=$$'$(call escape,$($(D)))' >> $(PATH_TO_DEFAULTS) $(LF))
	@echo DEFAULTS=$(DEFAULTS) >> $(PATH_TO_DEFAULTS)
	@echo DEVTOOLS_DIR=$(DEVTOOLS_DIR) >> $(PATH_TO_DEFAULTS)
	@echo SETTINGS=$(SETTINGS) >> $(PATH_TO_DEFAULTS)
endif

all: defaults
	$(foreach CTX,$(CTXES),cd $(DEVTOOLS_DIR) && while read LINE; do export "$$LINE"; done < $(PATH_TO_DEFAULTS) \
		&& $(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),$(subst $(CTX)__,,$(V))=$$'$(call escape,$($(V)))') \
		$(RENDER) --in=$($(CTX)__IN) --out=$($(CTX)__OUT) \
	$(LF))

ctxes:
	@echo SETTINGS = $(SETTINGS)
	@$(foreach CTX,$(CTXES),echo "ENABLE_$(CTX) = $(ENABLE_$(CTX)); $(CTX)__STAGE = $($(CTX)__STAGE)" $(LF))

envs:
	@echo SETTINGS = $(SETTINGS)
	@$(foreach CTX,$(CTXES),echo "$(CTX): enabled = $(ENABLE_$(CTX)); stage = $($(CTX)__STAGE)" $(LF) \
	$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),echo "    $(subst $(CTX)__,,$(V))='$($(V))'" $(LF)))
