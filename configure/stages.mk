DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

CLEANABLE += apps
CLEANABLE += build
CLEANABLE += deps
CLEANABLE += fixtures
CLEANABLE += init
CLEANABLE += reports
CLEANABLE += schemas
CLEANABLE += services
CLEANABLE += tests
CLEANABLE += upgrade
CLEANABLE += venvs

SERVICES_DELAY = 5

YES = yes
NO = no

ifeq ($(DRY_RUN),yes)
DR = n
else
DR =
endif

.PHONY: deps venvs init stop-disabled services schemas build fixtures upgrade apps stop-apps stop-services \
tests reports clean distclean

define runner
@echo "-------------------------- SUBSTAGE --------------------------"
@echo "SubStage: $1; target: $3."
@echo "--------------------------- BEGIN  ---------------------------"
$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $(ENABLE_$(CTX)),$2),$(CTX)))))
$(eval ECTXES = $(strip $(foreach CTX,$(ENABLED),$(if $(filter $($(CTX)__STAGE),$1),$(CTX)))))
$(foreach CTX,$(ECTXES),$(MAKE) -$(DR)f $($(CTX)__OUT) $3 ${LF})
@echo "---------------------------  END  ---------------------------"
endef

define stage_header
@echo "==================================================== STAGE ===================================================="
@echo "STAGE: $1."
@echo "==================================================== BEGIN ===================================================="
endef

define stage_tail
@echo "====================================================  END  ===================================================="
endef

deps:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),install)
	$(call stage_tail,$@)

venvs:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),init)
	$(call runner,pip,$(YES),init)
	$(call stage_tail,$@)

init-services:
	$(call stage_header,$@)
	$(call runner,init,$(YES),init)
	$(call stage_tail,$@)

clean-services:
	$(call stage_header,$@)
	$(call runner,init,$(YES),clean)
	$(call stage_tail,$@)

images:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),build)
	$(call stage_tail,$@)

tmux:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),init)
	$(call stage_tail,$@)

stop-disabled:
	$(call stage_header,$@)
	$(call runner,services,$(NO),stop)
	$(call runner,apps,$(NO),stop)
	$(call runner,docker-services,$(NO),rm)
	$(call runner,docker-apps,$(NO),rm)
	$(call stage_tail,$@)

stop-all: stop-disabled
	$(call stage_header,$@)
	$(call runner,services,$(YES),stop)
	$(call runner,apps,$(YES),stop)
	$(call runner,docker-services,$(YES),rm)
	$(call runner,docker-apps,$(YES),rm)
	$(call stage_tail,$@)

start-services:
	$(call stage_header,$@)
	$(call runner,services,$(YES),start)
	$(call runner,docker-services,$(YES),run)
	@echo "Waiting for services' runtime init ..."
	sleep $(SERVICES_DELAY)
	@echo Ok
	$(call stage_tail,$@)

stop-services:
	$(call stage_header,$@)
	$(call runner,services,$(YES),stop)
	$(call runner,docker-services,$(YES),rm)
	$(call stage_tail,$@)

schemas:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),start)
	$(call stage_tail,$@)

build:
	$(call stage_header,$@)
	$(call runner,cargo,$(YES),$@)
	$(call stage_tail,$@)

fixtures:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),start)
	$(call stage_tail,$@)

upgrade:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),start)
	$(call stage_tail,$@)

start-apps:
	$(call stage_header,$@)
	$(call runner,apps,$(YES),start)
	$(call runner,docker-apps,$(YES),run)
	$(call stage_tail,$@)

stop-apps:
	$(call stage_header,$@)
	$(call runner,apps,$(YES),stop)
	$(call runner,docker-apps,$(YES),rm)
	$(call stage_tail,$@)

docker-rm:
	$(call stage_header,$@)
	$(call runner,docker-services,$(YES),rm)
	$(call runner,docker-apps,$(YES),rm)
	$(call stage_tail,$@)

tests:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),start)
	$(call stage_tail,$@)

reports:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),upload)
	$(call stage_tail,$@)

clean:
	$(call stage_header,$@)
	$(call runner,$(CLEANABLE),$(YES),clean)
	$(call stage_tail,$@)

distclean:
	$(call stage_header,$@)
	$(call runner,$(CLEANABLE),$(YES),distclean)
	$(call stage_tail,$@)

tmux-kill-server:
	$(call stage_header,$@)
	$(call runner,tmux,$(YES),kill)
	$(call stage_tail,$@)

install:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),install)
	$(call stage_tail,$@)

uninstall:
	$(call stage_header,$@)
	$(call runner,$@,$(YES),uninstall)
	$(call stage_tail,$@)