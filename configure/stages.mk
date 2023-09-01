DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

ALL_STAGES += apps
ALL_STAGES += build
ALL_STAGES += deps
ALL_STAGES += fixtures
ALL_STAGES += init
ALL_STAGES += reports
ALL_STAGES += schemas
ALL_STAGES += services
ALL_STAGES += tests
ALL_STAGES += venvs

SERVICES_DELAY = 5

ifeq ($(DRY_RUN),yes)
DR = n
else
DR =
endif

.PHONY: deps venvs init stop-disabled services schemas build fixtures upgrade apps stop stop-services \
tests reports clean distclean ctxes

define runner
@echo "--------------------------- STAGE ---------------------------" ${LF}
@echo "STAGE: $1 ACTION: $3"
@echo "--------------------------- BEGIN ---------------------------" ${LF}
$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ctx_$(CTX)__ENABLED),$2),$(CTX)))))
$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $(ctx_$(CTX)__STAGE),$1),$(CTX)))))
$(foreach CTX,$(ECTXES),$(MAKE) -$(DR)f $($(CTX)__OUT) $3 ${LF})
$(info ECTXES = $(ECTXES))
@echo "---------------------------  END  ---------------------------" ${LF}
endef

deps:
	$(call runner,$@,yes,install)

venvs:
	$(call runner,$@,yes,init)
	$(call runner,pip,yes,init)

init:
	$(call runner,$@,yes,init)

images:
	$(call runner,$@,yes,build)

tmux:
	$(call runner,$@,yes,init)

stop-disabled:
	$(call runner,services,no,stop)
	$(call runner,apps,no,stop)
	$(call runner,docker-services,yes,rm)

services:
	$(call runner,$@,yes,start)
	$(call runner,docker-services,yes,run)
	@echo "Waiting for services' runtime init ..."
	sleep $(SERVICES_DELAY)
	@echo Ok

schemas:
	$(call runner,$@,yes,start)

build:
	$(call runner,$@,yes,$@)

fixtures:
	$(call runner,$@,yes,start)

apps:
	$(call runner,apps,yes,start)
	$(call runner,docker-apps,yes,run)

upgrade:
	$(call runner,$@,yes,start)

stop:
	$(call runner,apps,yes,stop)

stop-services:
	$(call runner,services,yes,stop)
	$(call runner,docker-services,yes,rm)

tests:
	$(call runner,$@,yes,start)

reports:
	$(call runner,$@,yes,upload)

clean-services:
	$(call runner,init,yes,clean)

clean:
	$(call runner,$(ALL_STAGES),yes,clean)

distclean:
	$(call runner,$(ALL_STAGES),yes,distclean)

tmux-kill-server:
	$(call runner,tmux,yes,kill)

ctxes:
	@echo SETTINGS = $(SETTINGS)
	@$(foreach CTX,$(CTXES),echo "$(CTX): enabled = $(ctx_$(CTX)__ENABLED); stage = $(ctx_$(CTX)__STAGE)" $(LF))
