SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
SELFDIR = $(realpath $(dir $(SELF)))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

PYTHON ?= {{ PYTHON }}
VENV_DIR ?= {{ VENV_DIR }}
VENV_PROMT ?= {{ VENV_PROMT }}

.PHONY: init clean distclean

$(VENV_DIR)/bin/python: $(PYTHON)
	[ -d $(VENV_DIR) ] || mkdir -p $(VENV_DIR)
	$(PYTHON) -m venv --prompt='$(VENV_PROMT)' $(VENV_DIR)

init: $(VENV_DIR)/bin/python

clean:
	[ ! -d $(VENV_DIR) ] || rm -Rf $(VENV_DIR)

distclean: clean
