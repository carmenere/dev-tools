LIB := {{ LIB }}
include $(LIB)/common.mk

LOG_FILE ?= {{ LOG_FILE }}
REPORTS_DIR ?= {{ REPORTS_DIR }}
TEST_CASES ?= {{ TEST_CASES }}
TEST_CASES_DIR ?= {{ TEST_CASES_DIR }}
PYTHON ?= {{ PYTHON }}
TMUX_START_CMD ?= {{ TMUX_START_CMD }}
MODE ?= {{ MODE }}

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
