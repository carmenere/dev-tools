TOPDIR := $(shell pwd)

ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
BIN_PATH ?= {{ BIN_PATH }}
LOG_FILE ?= {{ LOG_FILE }}
OPTS ?= {{ OPTS }}
PID_FILE ?= {{ PID_FILE }}
PKILL_PATTERN ?= {{ PKILL_PATTERN }}

{% set e = [] -%}
{% set e = [] -%}
{% if ENVS -%}
{% for item in ENVS.split(' ') -%}
{{ item }} = {{ env[item] }}
{% endfor -%}
{% for item in ENVS.split(' ') -%}
{% do e.append("{}=$({})".format(item, item)) -%}
{% endfor -%}
{% endif -%}

{% if e %}
ENVS ?= \
    {{ e|join(' \\\n    ') }}
{% endif %}
ifdef BIN_PATH
    START_BIN ?= $(ENVS) $(BIN_PATH) $(OPTS)
else
    START_BIN ?=
endif

TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir

.PHONY: init start stop start-daemon restart restart-daemon clean distclean

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

init: $(TGT_ARTEFACTS_DIR)

start: init
	echo $(ENVS) > $(LOG_FILE)
ifdef START_BIN
	bash -c '$(START_BIN) 2>&1 | tee -a $(LOG_FILE); exit $${PIPESTATUS[0]}'
endif

start-daemon: init
	echo $(ENVS) > $(LOG_FILE)
ifdef START_BIN
	$(START_BIN) >>$(LOG_FILE) 2>&1 & echo $$! > $(PID_FILE)
endif

restart: stop start

restart-daemon: stop start-daemon

stop:
ifdef PKILL_PATTERN
	@echo Killing $(PKILL_PATTERN) ...
	ps -A -o pid,command | grep -v grep | grep '$(PKILL_PATTERN)' | awk '{print $$1}' | xargs -I {} kill -s KILL {} || true
	@echo killed.
endif

clean:

distclean: stop
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)
