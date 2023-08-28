DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/..
TOPDIR ?= $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib

ALL_STAGES += apps
ALL_STAGES += build
ALL_STAGES += extensions
ALL_STAGES += fixtures
ALL_STAGES += init
ALL_STAGES += reports
ALL_STAGES += schemas
ALL_STAGES += services
ALL_STAGES += tests
ALL_STAGES += venvs

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk $(DEVTOOLS_DIR)/configure/ctxes.mk $(LIB)/common.mk

ifeq ($(DRY_RUN),yes)
DR = n
else
DR =
endif

.PHONY: extensions venvs init stop-disabled services schemas build fixtures upgrade apps stop stop-services \
tests reports clean distclean

define runner
@echo ">-----> STAGE: $1 <-----<" ${LF}
$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),$2),$(CTX)))))
$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$1),$(CTX)))))
$(foreach CTX,$(ECTXES),$(MAKE) -$(DR)f $($(CTX)__OUT) $3 ${LF})
@echo "<----- STAGE: $1 ----->" ${LF}
endef

extensions:
	$(call runner,$@,yes,install)

venvs:
	$(call runner,$@,yes,init)
	$(call runner,pip,yes,init)

init:
	$(call runner,$@,yes,init)

tmux:
	$(call runner,$@,yes,init)

stop-disabled:
	$(call runner,services apps,no,stop)

services:
	$(call runner,$@,yes,start)

schemas:
	$(call runner,$@,yes,start)

build:
	$(call runner,$@,yes,$@)

fixtures:
	$(call runner,$@,yes,start)

apps:
	$(call runner,apps,yes,start)

upgrade:
	$(call runner,$@,yes,start)

stop:
	$(call runner,apps,yes,stop)

stop-services:
	$(call runner,services,yes,stop)

tests:
	$(call runner,$@,yes,start)

reports:
	$(call runner,$@,yes,upload)

clean-services:
	$(call runner,services,yes,clean)

clean:
	$(call runner,$(ALL_STAGES),yes,clean)

distclean:
	$(call runner,$(ALL_STAGES),yes,distclean)

tmux-kill-server:
	$(call runner,tmux,yes,kill)

ctxes:
	@$(foreach CTX,$(CTXES),echo "$(CTX): enabled = $(ctx_$(CTX)__ENABLED); stage = $(ctx_$(CTX)__STAGE)" $(LF))
