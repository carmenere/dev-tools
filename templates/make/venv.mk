{%- import "common/defaults.j2" as d -%}
SELFDIR := {{ SELFDIR | default(d.SELFDIR, true) }}

PYTHON ?= {{ PYTHON | default(d.PYTHON, true) }}
VENV_DIR ?= {{ VENV_DIR | default('$(SELFDIR)/.venv', true) }}
VENV_PROMT ?= {{ VENV_PROMT | default('[VENV]', true) }}

.PHONY: init clean distclean

$(VENV_DIR)/bin/python:
	[ -d $(VENV_DIR) ] || mkdir -p $(VENV_DIR)
	$(PYTHON) -m venv --prompt='$(VENV_PROMT)' $(VENV_DIR)

init: $(VENV_DIR)/bin/python

clean:
	[ ! -d $(VENV_DIR) ] || rm -Rf $(VENV_DIR)

distclean: clean
