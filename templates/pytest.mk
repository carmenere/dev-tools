SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
SELFDIR = $(realpath $(dir $(SELF)))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

LOG_FILE ?= {{ LOG_FILE }}
REPORTS_DIR ?= {{ REPORTS_DIR }}
TEST_CASES ?= {{ TEST_CASES }}
TEST_CASES_DIR ?= {{ TEST_CASES_DIR }}
PYTHON ?= {{ PYTHON }}
TMUX_START_CMD ?= {{ TMUX_START_CMD }}
MODE ?= {{ MODE }}

CMD = $(ENVS) $(PYTHON) \
		-m pytest -v "$(TCASES)" \
		--color=yes \
		--junitxml=$(REPORTS_DIR)/junit_report.xml \
		--alluredir=$(REPORTS_DIR) \
		--allure-no-capture \
		--timeout=300

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

shell:
	$(CMD)

tee: 
	bash -c '$(CMD) 2>&1 | tee $(LOG_FILE); exit $${PIPESTATUS[0]}'

start: init $(MODE)

clean:
	[ ! -d $(REPORTS_DIR) ] || rm -Rf $(REPORTS_DIR)
	[ ! -f $(LOG_FILE) ] || rm -vf $(LOG_FILE)

distclean: clean
