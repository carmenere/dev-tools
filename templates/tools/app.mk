ENVS ?= {{ ENVS | default('', true) }}
OPTS ?= {{ OPTS | default('', true) }}
ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR | default('.artefacts', true) }}
BIN_PATH ?= {{ BIN_PATH | default('', true) }}
PKILL_PATTERN ?= {{ PKILL_PATTERN | default('$(BIN_PATH)', true) }}
VENV ?= {{ VENV | default('', true) }}
LOG_FILE ?= {{ LOG_FILE | default('$(ARTEFACTS_DIR)/logs.txt', true) }}
PID_FILE ?= {{ PID_FILE | default('$(ARTEFACTS_DIR)/.pid', true) }}

TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir

START_BIN ?= $(ENVS) $(BIN_PATH) $(OPTS)

.PHONY: init start stop start-daemon restart restart-daemon clean distclean

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

init: $(TGT_ARTEFACTS_DIR)
ifdef VENV
	$(MAKE) -f $(VENV) init
endif

start: init
	bash -c '$(START_BIN) 2>&1 | tee $(LOG_FILE); exit $${PIPESTATUS[0]}'

start-daemon: init
	$(START_BIN) >$(LOG_FILE) 2>&1 & echo $$! > $(PID_FILE)

restart: stop start

restart-daemon: stop start-daemon

stop:
	@echo Killing $(PKILL_PATTERN) ...
	ps -A -o pid,command | grep -v grep | grep '$(PKILL_PATTERN)' | awk '{print $$1}' | xargs -I {} kill -s KILL {} || true
	@echo killed.

clean:

distclean: stop
ifdef VENV
	$(MAKE) -f $(VENV) clean
endif
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)
