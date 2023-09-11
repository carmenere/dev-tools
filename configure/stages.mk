DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/..)

# Default vars
include $(DEVTOOLS_DIR)/configure/defaults.mk

# Customized vars
ifdef SETTINGS
    # Use '$(shell realpath ...)' because make's $(realpath ...) doesn't expand tilde '~'.
    include $(shell realpath $(SETTINGS))
endif

YES = yes
NO = no

ifeq ($(DRY_RUN),yes)
DR = n
else
DR =
endif

empty =
space = $(empty) $(empty)

.PHONY: deps venvs init-services clean-services images start-services schemas build fixtures upgrades start-apps stop-apps stop-services \
tests reports clean distclean docker-rm stop-all tmux tmux-kill-server install uninstall

define force_run
@echo "--------------- Force run CTXES filtered by TAGS ----------------"
@echo "Ctxes: $1."
@echo "Tags: $2. Target: $3."
@echo "----------------------------- START -----------------------------"
$(eval ECTXES = $(strip \
	$(foreach CTX,$1, \
		$(if $(filter $(subst $(space),_,$(sort $(filter $2,$($(CTX)__TAGS)))),$(subst $(space),_,$(sort $2))),$(CTX)) \
	)) \
)
$(foreach CTX,$(ECTXES),$(MAKE) -$(DR)f $($(CTX)__OUT) $3 ${LF})
@echo "-----------------------------  STOP  ----------------------------"
endef

define run
@echo "------------------ Run CTXES filtered by TAGS -------------------"
@echo "Tags: $1. Target: $2."
@echo "----------------------------- START -----------------------------"
$(eval ENABLED = $(strip $(foreach CTX,$(CTXES),$(if $(filter $($(CTX)__ENABLE),yes),$(CTX)))))
$(eval ECTXES = $(strip \
	$(foreach CTX,$(ENABLED), \
		$(if $(filter $(subst $(space),_,$(sort $(filter $1,$($(CTX)__TAGS)))),$(subst $(space),_,$(sort $1))),$(CTX)) \
	)) \
)
$(foreach CTX,$(ECTXES),$(MAKE) -$(DR)f $($(CTX)__OUT) $2 ${LF})
@echo "-----------------------------  STOP  ----------------------------"
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
	$(call run,dep,install)
	$(call stage_tail,$@)

venvs:
	$(call stage_header,$@)
	$(call run,venv,init)
	$(call run,pip,init)
	$(call stage_tail,$@)

init-services:
	$(call stage_header,$@)
	$(call run,cli,init)
	$(call stage_tail,$@)

clean-services:
	$(call stage_header,$@)
	$(call run,cli,clean)
	$(call stage_tail,$@)

images:
	$(call stage_header,$@)
	$(call run,image,build)
	$(call stage_tail,$@)

tmux:
	$(call stage_header,$@)
	$(call run,tmux,init)
	$(call stage_tail,$@)

stop-all:
ifeq ($(STOP_ALL),yes)
	$(call stage_header,$@)
	$(call force_run,$(CTXES),app,stop)
	$(call force_run,$(CTXES),service,stop)
	$(call force_run,$(CTXES),docker,rm)
	$(call force_run,$(CTXES),tmux,stop)
	$(call stage_tail,$@)
endif

start-services:
	$(call stage_header,$@)
	$(call run,service,start)
	$(call run,service,start)
	@echo "Waiting for services' runtime init ..."
	sleep $(SERVICES_DELAY)
	@echo Ok
	$(call stage_tail,$@)

stop-services:
	$(call stage_header,$@)
	$(call run,service,stop)
	$(call run,service docker,rm)
	$(call stage_tail,$@)

schemas:
	$(call stage_header,$@)
	$(call run,schema,start)
	$(call stage_tail,$@)

build:
	$(call stage_header,$@)
	$(call run,build,build)
	$(call stage_tail,$@)

fixtures:
	$(call stage_header,$@)
	$(call run,fixture,start)
	$(call stage_tail,$@)

upgrades:
	$(call stage_header,$@)
	$(call run,upgrade,start)
	$(call stage_tail,$@)

start-apps:
	$(call stage_header,$@)
	$(call run,app,start)
	$(call stage_tail,$@)

stop-apps:
	$(call stage_header,$@)
	$(call run,app,stop)
	$(call run,docker app,rm)
	$(call stage_tail,$@)

docker-rm:
	$(call stage_header,$@)
	$(call run,docker,rm)
	$(call run,docker,network-rm)
	$(call stage_tail,$@)

tests:
	$(call stage_header,$@)
	$(call run,test,start)
	$(call stage_tail,$@)

reports:
	$(call stage_header,$@)
	$(call run,report,upload)
	$(call stage_tail,$@)

clean:
	$(call stage_header,$@)
	$(call run,clean,clean)
	$(call stage_tail,$@)

distclean:
	$(call stage_header,$@)
	$(call run,clean,distclean)
	$(call stage_tail,$@)

tmux-kill-server:
	$(call stage_header,$@)
	$(call run,tmux,kill)
	$(call stage_tail,$@)

install:
	$(call stage_header,$@)
	$(call run,install,install)
	$(call stage_tail,$@)

uninstall:
	$(call stage_header,$@)
	$(call run,install,uninstall)
	$(call stage_tail,$@)