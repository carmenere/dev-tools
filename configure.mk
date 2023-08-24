
DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib

PROJECT_ROOT ?= $(TOPDIR)

# Default vars
include $(DEVTOOLS_DIR)/vars/defaults.mk $(DEVTOOLS_DIR)/vars/ctxes.mk $(LIB)/common.mk

# Customized vars
ifdef VARS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(VARS))
endif

RENDER ?= $(RENDER_PYTHON) -m render.main
SHELL ?= $(which bash)

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

.PHONY: all

# 1. Put CTX's envs to Render's envs.
# 2. Put CTX's vars to Render's cli args.
all:
	$(foreach CTX,$(CTXES),echo CTX=$(CTX) && cd $(DEVTOOLS_DIR) && \
		$(foreach VAR,$(filter envs_$(CTX)__%,$(.VARIABLES)),$(subst envs_$(CTX)__,,$(VAR))=$$'$(call escape,$($(VAR)))')\
		$(RENDER) \
		$(foreach V,$(filter $(CTX)__%,$(.VARIABLES)),--$(subst $(CTX)__,,$(V))=$$'$(call escape,$($(V)))') \
	$(LF))

# generic-run:
# 	$(foreach S,$(STAGES), \
# 		$(eval STAGE = $(firstword $(subst -, ,$@))) \
# 		$(eval TGT = $(lastword $(subst -, ,$@))) \
# 		$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX))))) \
# 		$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX))))) \
# 		$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF}) \
# 	$(LF))

build-build:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

venv-init:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

pip-requirements:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

apps-start:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

schemas-start:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

sysctl-start:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

tests-run:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

tmux-init:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

docker-build:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

docker-run:
	@echo "===> STAGE = $@ <==="
	$(eval STAGE = $(firstword $(subst -, ,$@)))
	$(eval TGT = $(lastword $(subst -, ,$@)))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval CT = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STAGE)),$(CTX)))))
	$(foreach CTX,$(CT),$(MAKE) -nf $($(CTX)__OUT) $(TGT) ${LF})

run: $(STAGES)

tmux-start:
ifdef HOST_APPS
	$(MAKE) -f $(TMUX_MAKE) init
	$(foreach V,$(HOST_APPS),$(MAKE) -f $(TMUX_MAKE) exec CMD='$(MAKE) -f $($(V)_MAKE) start' WINDOW_NAME=$($(V)_APP) ${LF})
endif

tmux-stop:
ifdef HOST_APPS
	$(foreach V,$(HOST_APPS),$(MAKE) -f $($(V)_MAKE) stop ${LF})
endif
	$(MAKE) -f $(TMUX_MAKE) close-session

tmux-kill:
	$(MAKE) -f $(TMUX_MAKE) kill-server

connect: 
	$(MAKE) -f $(TMUX_MAKE) connect
