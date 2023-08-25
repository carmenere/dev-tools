TOPDIR := $(shell pwd)

ADMIN ?= {{ ADMIN }}
ADMIN_DB ?= {{ ADMIN_DB }}
ADMIN_PASSWORD ?= {{ ADMIN_PASSWORD }}
ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
CNT = {{ CNT }}
HOST ?= {{ HOST }}
MODE = {{ MODE }}
PORT ?= {{ PORT }}
REQUIREPASS ?= {{ REQUIREPASS }}
USER_DB ?= {{ USER_DB }}
USER_NAME := {{ USER_NAME }}
USER_PASSWORD ?= {{ USER_PASSWORD }}

CONN_URL ?= redis://$(ADMIN):"$(ADMIN_PASSWORD)"@$(HOST):$(PORT)/$(ADMIN_DB)
USER_CONN_URL ?= redis-cli -u redis://$(USER_NAME):$(USER_PASSWORD)@$(HOST):$(PORT)/$(USER_DB)

#
ifdef CNT
    REDIS_CLI ?= docker exec $(TI) $(CNT) redis-cli -u $(CONN_URL)
    REDIS_CLI_USER ?= docker exec $(TI) $(CNT) redis-cli -u $(USER_CONN_URL)
else
    REDIS_CLI ?= redis-cli -u $(CONN_URL)
    REDIS_CLI_USER ?= redis-cli -u $(USER_CONN_URL)
endif

ifeq ($(REQUIREPASS),yes)
    SET_REQUIRE_PASS ?= $(REDIS_CLI) config set requirepass "$(ADMIN_PASSWORD)"
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
	[ -f $(TGT_CREATE_USER) ] || $(REDIS_CLI) ACL SETUSER $(USER_NAME) \>$(USER_PASSWORD) on allkeys allcommands
	$(REDIS_CLI) CONFIG REWRITE
	[ -f $(TGT_CREATE_USER) ] || touch $@

init: $(TGT_CREATE_USER)

connect: override TI = -ti
connect:
	$(REDIS_CLI_USER)

connect-admin: override TI = -ti
connect-admin:
	$(REDIS_CLI)

drop:
	[ ! -f $(TGT_CREATE_USER) ] || $(REDIS_CLI) ACL DELUSER $(USER_NAME)
	$(REDIS_CLI) CONFIG REWRITE

force-drop:
	$(REDIS_CLI) ACL DELUSER $(USER_NAME) || true
	$(REDIS_CLI) CONFIG REWRITE

clean-artefacts:
	[ ! -f $(TGT_CREATE_USER) ] || rm -fv $(TGT_CREATE_USER)

flush:
	$(REDIS_CLI) FLUSHALL
	$(REDIS_CLI) config set requirepass ""
	$(REDIS_CLI) CONFIG REWRITE

clean: drop clean-artefacts flush

force-clean: force-drop clean-artefacts flush

distclean: clean
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)
