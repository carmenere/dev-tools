TOPDIR := $(shell pwd)

ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
LOG_FILE ?= {{ LOG_FILE }}
REPORTS_DIR ?= {{ REPORTS_DIR }}
TEST_CASES ?= {{ TEST_CASES }}
TEST_CASES_DIR ?= {{ TEST_CASES_DIR }}
PYTHON ?= {{ PYTHON }}

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

# Targets
TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir

.PHONY: init run clean distclean

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

init: $(TGT_ARTEFACTS_DIR)

run: init
	bash -c '$(ENVS) $(PYTHON) \
		-m pytest -v "$(TCASES)" \
		--color=yes \
		--junitxml=$(ARTEFACTS_DIR)/junit_report.xml \
		--alluredir=$(REPORTS_DIR) \
		--allure-no-capture \
		--timeout=300 \
	2>&1 | tee $(LOG_FILE); exit $${PIPESTATUS[0]}'

clean:
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)

distclean: clean
