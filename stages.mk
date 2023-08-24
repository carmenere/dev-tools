DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib

# Default vars
include $(DEVTOOLS_DIR)/vars/defaults.mk $(DEVTOOLS_DIR)/vars/ctxes.mk $(LIB)/common.mk

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

# tmux-kill:
# 	$(MAKE) -f $(TMUX_MAKE) kill-server

# connect: 
# 	$(MAKE) -f $(TMUX_MAKE) connect
