TOPDIR := $(shell pwd)

ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
INSTALL_SCHEMA ?= {{ INSTALL_SCHEMA }}
USERBASE ?= {{ USERBASE }}
PYTHON ?= {{ PYTHON }}
REQUIREMENTS ?= {{ REQUIREMENTS }}
export CC ?= {{ CC }}
export CPPFLAGS ?= {{ CPPFLAGS }}
export CXX ?= {{ CXX }}
export LDFLAGS ?= {{ LDFLAGS }}

PIP ?= $(PYTHON) -m pip

PACKAGE ?=

TGT_INSTALL_REQUIREMENTS ?= $(ARTEFACTS_DIR)/.install-requirements-$(shell echo $(REQUIREMENTS) | tr '/' '-')
TGT_UPGRADE ?= $(ARTEFACTS_DIR)/.upgrade
TGT_INSTALL_PACKAGE ?= $(ARTEFACTS_DIR)/.install-requirements-$(shell echo $(PACKAGE) | tr '/' '-')

ifdef USERBASE
    PYTHONUSERBASE = PYTHONUSERBASE='$(USERBASE)'
else
	PYTHONUSERBASE =
endif

PIP_OPTS += $(INSTALL_SCHEMA)
ifeq ($(BREAK_SYSTEM_PACKAGES),yes)
PIP_OPTS += --break-system-packages
endif
ifeq ($(PREFER_BINARY),yes)
PIP_OPTS += --prefer-binary
endif

ifneq ($(UPGRADE_PIP),no)
UPGRADE += pip
endif
ifneq ($(UPGRADE_WHEEL),no)
UPGRADE += wheel
endif
ifneq ($(UPGRADE_SETUPTOOLS),no)
UPGRADE += setuptools
endif

.PHONY: upgrade install requirements clean distclean

$(TGT_UPGRADE):
	[ -d $(ARTEFACTS_DIR) ] || mkdir -p $(ARTEFACTS_DIR)
	@echo PYTHONUSERBASE = $(PYTHONUSERBASE)
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) --upgrade $(UPGRADE)
	touch $@

$(TGT_INSTALL_REQUIREMENTS): $(REQUIREMENTS)
	[ -d $(ARTEFACTS_DIR) ] || mkdir -p $(ARTEFACTS_DIR)
ifdef REQUIREMENTS
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) -r $(REQUIREMENTS)
endif
	touch $@

$(TGT_INSTALL_PACKAGE):
ifdef REQUIREMENTS
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) $(PACKAGE)
endif
	touch $@

upgrade: $(TGT_UPGRADE)

install: upgrade $(TGT_INSTALL_PACKAGE)

requirements: upgrade $(TGT_INSTALL_REQUIREMENTS)

clean:
	[ ! -d $(ARTEFACTS_DIR) ] || rm -Rf $(ARTEFACTS_DIR)

distclean: clean