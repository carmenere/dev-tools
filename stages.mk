DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib

# Default vars
include $(DEVTOOLS_DIR)/vars/defaults.mk $(DEVTOOLS_DIR)/vars/ctxes.mk $(LIB)/common.mk

DRY_RUN = n

START_STAGES += docker--build
START_STAGES += sysctl--start
START_STAGES += docker--run
START_STAGES += schemas--start
START_STAGES += build--build
START_STAGES += venv--init
START_STAGES += pip--requirements
START_STAGES += tmux--init
START_STAGES += apps--start

.PHONY: start

start:
	$(foreach STAGE,$(START_STAGES), \
		@echo "===> STAGE = $(STAGE) <===" ${LF} \
		$(eval STG = $(firstword $(subst --, ,$(STAGE)))) \
		$(eval TGT = $(lastword $(subst --, ,$(STAGE)))) \
		$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX))))) \
		$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STG)),$(CTX))))) \
		$(foreach CTX,$(ECTXES),$(MAKE) -$(DRY_RUN)f $($(CTX)__OUT) $(TGT) ${LF}) \
	)

tests:
	$(eval STAGE = tests--run)
	@echo "===> STAGE = $(STAGE) <===" ${LF} \
	$(eval STG = $(firstword $(subst --, ,$(STAGE))))
	$(eval TGT = $(lastword $(subst --, ,$(STAGE))))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STG)),$(CTX)))))
	$(foreach CTX,$(ECTXES),$(MAKE) -$(DRY_RUN)f $($(CTX)__OUT) $(TGT) ${LF})

tmux-kill:
	$(eval STAGE = tmux--kill-server)
	@echo "===> STAGE = $(STAGE) <===" ${LF} \
	$(eval STG = $(firstword $(subst --, ,$(STAGE))))
	$(eval TGT = $(lastword $(subst --, ,$(STAGE))))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STG)),$(CTX)))))
	$(foreach CTX,$(ECTXES),$(MAKE) -$(DRY_RUN)f $($(CTX)__OUT) $(TGT) ${LF})
