{% import "common/defaults.j2" as d %}
SELFDIR := {{ SELFDIR | default(d.SELFDIR, true) }}
OUT := {{ OUT }}

APP ?= {{ APP }}
BIN_PATH ?= {{ BIN_PATH }}
LOG_FILE ?= {{ LOG_FILE | default('$(SELFDIR)/.logs', true) }}
OPTS ?= {{ OPTS | default('', true) }}
PID_FILE ?= {{ PID_FILE | default('$(SELFDIR)/.pid', true) }}
PKILL_PATTERN ?= {{ PKILL_PATTERN | default('$(BIN_PATH)', true) }}
TMUX ?= {{ TMUX }}
MODE ?= {{ MODE | default('tee', true) }}

TMUX_START_CMD = $(MAKE) -f $(TMUX) exec CMD='$(MAKE) -f $(OUT) tee' WINDOW_NAME=$(APP)

# LIB
{% include 'common/lib.mk' %}

# ENVS
{% include 'common/envs.jinja2' %}

ifdef BIN_PATH
    START_BIN ?= $(ENVS) $(BIN_PATH) $(OPTS)
else
    START_BIN ?=
endif

.PHONY: shell daemon tmux tee start stop restart clean distclean

shell:
	echo ENVS = $$'$(call escape,$(ENVS))' > $(LOG_FILE)
ifdef START_BIN
	bash -c $$'$(call escape,$(START_BIN); exit $${PIPESTATUS[0]})'
endif

tmux:
	$(TMUX_START_CMD)

tee:
	echo ENVS = $$'$(call escape,$(ENVS))' > $(LOG_FILE)
ifdef START_BIN
	bash -c $$'$(call escape,$(START_BIN) 2>&1 | tee -a $(LOG_FILE); exit $${PIPESTATUS[0]})'
endif

daemon:
	echo ENVS = $$'$(call escape,$(ENVS))' > $(LOG_FILE)
ifdef START_BIN
	$(START_BIN) >>$(LOG_FILE) 2>&1 & echo $$! > $(PID_FILE)
endif

start: $(MODE)

stop:
ifdef PKILL_PATTERN
	@echo Killing $(PKILL_PATTERN) ...
	ps -A -o pid,command | grep -v grep | grep '$(PKILL_PATTERN)' | awk '{print $$1}' | xargs -I {} kill -s KILL {} || true
	@echo killed.
endif

restart: stop $(MODE)

clean: stop
	[ ! -f $(LOG_FILE) ] || rm -vf $(LOG_FILE)
	[ ! -f $(PID_FILE) ] || rm -vf $(PID_FILE)

distclean: stop clean