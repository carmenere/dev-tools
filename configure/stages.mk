DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/..
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk $(DEVTOOLS_DIR)/configure/ctxes.mk $(LIB)/common.mk

DRY_RUN = n

# STAGES:
#   extensions
#   images: docker build
#   services: sysctl, docker run
#   init: venvs, pips reqs, creds
#   schemas: app.mk
#   build: app.mk
#   fixtures: app.mk
#   upgrade: app.m
#   apps: exec (for tmux), app, docker run
#   upload:

START_STAGES += docker--build
START_STAGES += services--start
START_STAGES += docker--run
START_STAGES += schemas--start
START_STAGES += build--build
START_STAGES += venv--init
START_STAGES += pip--init
START_STAGES += tmux--init
START_STAGES += apps--start

.PHONY: start

start:
	$(foreach STAGE,$(START_STAGES), \
		@echo "===> STAGE: $(STAGE) <===" ${LF} \
		$(eval STG = $(firstword $(subst --, ,$(STAGE)))) \
		$(eval TGT = $(lastword $(subst --, ,$(STAGE)))) \
		$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX))))) \
		$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STG)),$(CTX))))) \
		$(foreach CTX,$(ECTXES),$(MAKE) -$(DRY_RUN)f $($(CTX)__OUT) $(TGT) ${LF}) \
	)

tests:
	$(eval STAGE = tests)
	@echo "===> STAGE: $(STAGE) <===" ${LF} \
	$(eval STG = $(firstword $(subst --, ,$(STAGE))))
	$(eval TGT = $(lastword $(subst --, ,$(STAGE))))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STG)),$(CTX)))))
	$(foreach CTX,$(ECTXES),$(MAKE) -$(DRY_RUN)f $($(CTX)__OUT) $(TGT) ${LF})

reports:
	$(eval STAGE = reposts)
	@echo "===> STAGE: $(STAGE) <===" ${LF} \
	$(eval STG = $(firstword $(subst --, ,$(STAGE))))
	$(eval TGT = $(lastword $(subst --, ,$(STAGE))))
	$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),yes),$(CTX)))))
	$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$(STG)),$(CTX)))))
	$(foreach CTX,$(ECTXES),$(MAKE) -$(DRY_RUN)f $($(CTX)__OUT) $(TGT) ${LF})