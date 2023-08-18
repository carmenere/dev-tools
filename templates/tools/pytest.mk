ALLURE ?= {{ ALLURE | default('', true) }}
ENVS ?= {{ ENVS | default('', true) }}
ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR | default('.artefacts', true) }}
REPORTS_DIR ?= {{ REPORTS_DIR | default('', true) }}
TEST_CASES ?= {{ TEST_CASES | default('', true) }}
TEST_CASES_DIR ?= {{ TEST_CASES_DIR | default('', true) }}
VENV ?= {{ VENV | default('', true) }}
VENV_DIR ?= {{ VENV_DIR | default('', true) }}
LOG_FILE ?= {{ LOG_FILE | default('$(ARTEFACTS_DIR)/logs.txt', true) }}

ifdef TEST_CASES
    TCASES = $(foreach T,$(TEST_CASES),$(TEST_CASES_DIR)/$(T))
else
    TCASES = $(TEST_CASES_DIR)
endif

#
VPYTHON ?= $(VENV_DIR)/bin/python

# Targets
TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir

.PHONY: init run upload clean distclean

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

init: $(TGT_ARTEFACTS_DIR)
ifdef ALLURE
	$(MAKE) -f $(ALLURE) init
endif
ifdef VENV
	$(MAKE) -f $(VENV) init
endif

run: init
	bash -c '$(ENVS) $(VPYTHON) \
		-m pytest -v "$(TCASES)" \
		--color=yes \
		--junitxml=$(ARTEFACTS_DIR)/junit_report.xml \
		--alluredir=$(REPORTS_DIR) \
		--allure-no-capture \
		--timeout=300 \
	2>&1 | tee $(LOG_FILE); exit $${PIPESTATUS[0]}'

upload:
ifdef ALLURE
	$(MAKE) -f $(ALLURE) upload
endif

clean:

distclean:
ifdef ALLURE
	$(MAKE) -f $(ALLURE) clean-reports
endif
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)
