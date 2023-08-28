TOPDIR := $(shell pwd)


INSTALL_SCHEMA ?= {{ INSTALL_SCHEMA }}
USERBASE ?= {{ USERBASE }}
PYTHON ?= {{ PYTHON }}
REQUIREMENTS ?= {{ REQUIREMENTS }}
export CC ?= {{ CC }}
export CPPFLAGS ?= {{ CPPFLAGS }}
export CXX ?= {{ CXX }}
export LDFLAGS ?= {{ LDFLAGS }}

SITE_PACKAGES = $(shell $(PYTHON) -m pip show pip | grep Location | cut -d':' -f 2)
PIP ?= $(PYTHON) -m pip

PACKAGE ?=

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

$(SITE_PACKAGES)/.upgrade:
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) --upgrade $(UPGRADE)
	touch $@

$(SITE_PACKAGES)/.requirements: $(REQUIREMENTS)
ifdef REQUIREMENTS
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) -r $(REQUIREMENTS)
endif
	cp -f $(REQUIREMENTS) $(SITE_PACKAGES)/.requirements && touch $@

$(SITE_PACKAGES)/.package-$(PACKAGE):
ifdef REQUIREMENTS
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) $(PACKAGE)
endif
	touch $@

upgrade: $(SITE_PACKAGES)/.upgrade

install: upgrade $(SITE_PACKAGES)/.package-$(PACKAGE)

requirements: upgrade $(SITE_PACKAGES)/.requirements

init: requirements

clean:
	pip uninstall -r $(REQUIREMENTS) -y
	[ ! -f $(SITE_PACKAGES)/.package-* ] || rm -fv $(SITE_PACKAGES)/.package-*
	[ ! -f $(SITE_PACKAGES)/.requirements ] || rm -fv $(SITE_PACKAGES)/.requirements
	[ ! -f $(SITE_PACKAGES)/.upgrade ] || rm -fv $(SITE_PACKAGES)/.upgrade

distclean: clean