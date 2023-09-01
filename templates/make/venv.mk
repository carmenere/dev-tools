SELFDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

include {{ SETTINGS }}

PYTHON ?= {{ PYTHON | default('$(d__PYTHON)', true) }}
VENV_DIR ?= {{ VENV_DIR | default('$(SELFDIR)/.venv', true) }}
VENV_PROMT ?= {{ VENV_PROMT | default('[VENV]', true) }}

.PHONY: init clean distclean

$(VENV_DIR)/bin/python: $(PYTHON)
	[ -d $(VENV_DIR) ] || mkdir -p $(VENV_DIR)
	$(PYTHON) -m venv --prompt='$(VENV_PROMT)' $(VENV_DIR)

init: $(VENV_DIR)/bin/python

clean:
	[ ! -d $(VENV_DIR) ] || rm -Rf $(VENV_DIR)

distclean: clean
