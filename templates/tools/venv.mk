TOPDIR := {{ TOPDIR }}

PYTHON ?= {{ PYTHON }}
REQUIREMENTS ?= {{ REQUIREMENTS }}
VENV_DIR ?= {{ VENV_DIR }}
VENV_PROMT ?= {{ VENV_PROMT }}
VPYTHON = {{ VPYTHON }}

export CC ?= {{ CC }}
export CPPFLAGS ?= {{ CPPFLAGS }}
export CXX ?= {{ CXX }}
export LDFLAGS ?= {{ LDFLAGS }}

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
