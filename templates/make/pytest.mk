SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
SELFDIR = $(realpath $(dir $(SELF)))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

LOG_FILE ?= {{ LOG_FILE | default('$(SELFDIR)/.logs', true) }}
REPORTS_DIR ?= {{ REPORTS_DIR | default('$(SELFDIR)/.reports', true) }}
TEST_CASES ?= {{ TEST_CASES | default('', true) }}
TEST_CASES_DIR ?= {{ TEST_CASES_DIR | default('tests', true) }}
PYTHON ?= {{ PYTHON | default(d['PYTHON'], true) }}
TMUX_START_CMD ?= {{ TMUX_START_CMD | default('', true) }}
MODE ?= {{ MODE | default('tee', true) }}

{% include 'common/j2/envs.jinja2' %}

ifdef TEST_CASES
    TCASES = $(foreach T,$(TEST_CASES),$(TEST_CASES_DIR)/$(T))
else
    TCASES = $(TEST_CASES_DIR)
endif

.PHONY: init run clean distclean

init:

tmux:
	$(TMUX_START_CMD)

run: init
	bash -c '$(ENVS) $(PYTHON) \
		-m pytest -v "$(TCASES)" \
		--color=yes \
		--junitxml=$(REPORTS_DIR)/junit_report.xml \
		--alluredir=$(REPORTS_DIR) \
		--allure-no-capture \
		--timeout=300 \
	2>&1 | tee $(LOG_FILE); exit $${PIPESTATUS[0]}'

start: $(MODE)

clean:
	[ ! -d $(REPORTS_DIR) ] || rm -Rf $(REPORTS_DIR)
	[ ! -f $(LOG_FILE) ] || rm -vf $(LOG_FILE)


distclean: clean
