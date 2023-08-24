TOPDIR := $(shell pwd)

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
CONTAINER = {{ CONTAINER }}
HOST ?= {{ HOST }}
MODE = {{ MODE }}
PORT ?= {{ PORT }}
REQUIREPASS ?= {{ REQUIREPASS }}
USER_DB ?= {{ USER_DB }}
USER_NAME := {{ USER_NAME }}
USER_PASSWORD ?= {{ USER_PASSWORD }}

ifeq ($(strip $(MODE)$(CONTAINER)),docker)
    $(error For MODE=docker var CONTAINER must be defined!)
endif

ifeq ($(strip $(MODE)),docker)
    DOCKER_EXEC = docker exec $(TI) $(CONTAINER)
else ifeq ($(MODE),host)
    DOCKER_EXEC = 
else
    $(error Unknown value '$(MODE)' for var 'MODE'.)
endif

#
REDIS_CLI_ADMIN = $(DOCKER_EXEC) redis-cli -u redis://$(ADMIN):"$(ADMIN_PASSWORD)"@$(HOST):$(PORT)/$(ADMIN_DB)
REDIS_CLI = $(DOCKER_EXEC) redis-cli -u redis://$(USER_NAME):$(USER_PASSWORD)@$(HOST):$(PORT)/$(USER_DB)

ifeq ($(REQUIREPASS),yes)
    SET_REQUIRE_PASS ?= $(REDIS_CLI_ADMIN) config set requirepass "$(ADMIN_PASSWORD)"
else
    SET_REQUIRE_PASS ?= echo ""
endif

# Targets
TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir
TGT_CREATE_USER ?= $(ARTEFACTS_DIR)/.$(MODE)-create-user-$(USER_NAME)-$(USER_PASSWORD)

.PHONY: init clean force-clean distclean drop force-drop clean-artefacts connect

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

$(TGT_CREATE_USER): $(TGT_ARTEFACTS_DIR)
	[ -f $(TGT_CREATE_USER) ] || $(SET_REQUIRE_PASS)
	[ -f $(TGT_CREATE_USER) ] || $(REDIS_CLI_ADMIN) ACL SETUSER $(USER_NAME) \>$(USER_PASSWORD) on allkeys allcommands
	$(REDIS_CLI_ADMIN) CONFIG REWRITE
	[ -f $(TGT_CREATE_USER) ] || touch $@

init: $(TGT_CREATE_USER)

connect: override TI = -ti
connect:
	$(REDIS_CLI)

drop:
	[ ! -f $(TGT_CREATE_USER) ] || $(REDIS_CLI_ADMIN) ACL DELUSER $(USER_NAME)
	$(REDIS_CLI_ADMIN) CONFIG REWRITE

force-drop:
	$(REDIS_CLI_ADMIN) ACL DELUSER $(USER_NAME) || true
	$(REDIS_CLI_ADMIN) CONFIG REWRITE

clean-artefacts:
	[ ! -f $(TGT_CREATE_USER) ] || rm -fv $(TGT_CREATE_USER)

flush:
	$(REDIS_CLI_ADMIN) FLUSHALL
	$(REDIS_CLI_ADMIN) config set requirepass ""
	$(REDIS_CLI_ADMIN) CONFIG REWRITE

clean: drop clean-artefacts flush

force-clean: force-drop clean-artefacts flush

distclean: clean
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)
