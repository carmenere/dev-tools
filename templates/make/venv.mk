TOPDIR := $(shell pwd)

PYTHON ?= {{ PYTHON }}
VENV_DIR ?= {{ VENV_DIR }}
VENV_PROMT ?= {{ VENV_PROMT }}

.PHONY: init clean distclean

$(VENV_DIR)/bin/python:
	[ -d $(VENV_DIR) ] || mkdir -p $(VENV_DIR)
	$(PYTHON) -m venv --prompt='$(VENV_PROMT)' $(VENV_DIR)

init: $(VENV_DIR)/bin/python

clean:
	[ ! -d $(VENV_DIR) ] || rm -Rf $(VENV_DIR)

distclean: clean
