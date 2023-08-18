TOPDIR := {{ TOPDIR | default('$(shell pwd)', true) }}

PYTHON ?= {{ PYTHON | default('$(shell which python3.11)', true) }}
VENV_PROMT ?= {{ VENV_PROMT | default('[VENV]', true) }}
VENV_DIR ?= {{ VENV_DIR | default('$(PWD)/.venv', true) }}
VPYTHON = {{ VPYTHON | default('$(VENV_DIR)/bin/python', true) }}
REQUIREMENTS ?= {{ REQUIREMENTS }}

export CPPFLAGS ?= {{ CPPFLAGS | default('$(shell echo $${CPPFLAGS})', true) }}
export LDFLAGS ?= {{ LDFLAGS | default('$(shell echo $${LDFLAGS})', true) }}
export CC ?= {{ CC | default('$(shell echo $${CC})', true) }}
export CXX ?= {{ CXX | default('$(shell echo $${CXX})', true) }}

TGT_INSTALL_REQUIREMENTS ?= $(VENV_DIR)/.install-requirements
TGT_UPGRADE_SETUPTOOLS ?= $(VENV_DIR)/.upgrade

.PHONY: init clean distclean

$(VPYTHON):
	[ -d $(VENV_DIR) ] || mkdir -p $(VENV_DIR)
	$(PYTHON) -m venv --prompt='$(VENV_PROMT)' $(VENV_DIR)

$(TGT_UPGRADE_SETUPTOOLS): $(VPYTHON)
	$(VPYTHON) -m pip install --upgrade pip
	$(VPYTHON) -m pip install --upgrade wheel
	$(VPYTHON) -m pip install --upgrade setuptools
	touch $@

$(TGT_INSTALL_REQUIREMENTS): $(REQUIREMENTS)
ifdef REQUIREMENTS
	$(VPYTHON) -m pip install --prefer-binary -r $(REQUIREMENTS)
endif
	touch $@

init: $(TGT_UPGRADE_SETUPTOOLS) $(TGT_INSTALL_REQUIREMENTS)

clean:
	[ ! -d $(VENV_DIR) ] || rm -Rf $(VENV_DIR)

distclean: clean
