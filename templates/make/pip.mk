SELFDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}
SETTINGS ?= {{ SETTINGS }}

include $(DEVTOOLS_DIR)/configure/defaults.mk
include $(DEVTOOLS_DIR)/templates/make/common/lib.mk

ifdef SETTINGS
    include $(SETTINGS)
endif

PYTHON ?= {{ PYTHON | default('$(d__PYTHON)', true) }}
INSTALL_SCHEMA ?= {{ INSTALL_SCHEMA | default('', true)}}
USERBASE ?= {{ USERBASE | default('', true)}}
REQUIREMENTS ?= {{ REQUIREMENTS | default('requirements.txt', true)}}

export CC = {{ CC | default('$(d__CC)', true)}}
export CPPFLAGS = {{ CPPFLAGS | default('$(d__CPPFLAGS)', true)}}
export CXX = {{ CXX | default('$(d__CXX)', true)}}
export LDFLAGS = {{ LDFLAGS | default('$(d__LDFLAGS)', true)}}

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

.PHONY: upgrade install requirements init clean distclean

$(SITE_PACKAGES)/.upgrade: $(PYTHON)
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) --upgrade $(UPGRADE)
	touch $@

$(SITE_PACKAGES)/.requirements: $(SITE_PACKAGES)/.upgrade $(REQUIREMENTS)
ifdef REQUIREMENTS
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) -r $(REQUIREMENTS)
endif
	cp -f $(REQUIREMENTS) $(SITE_PACKAGES)/.requirements
	touch $@

$(SITE_PACKAGES)/.package-$(PACKAGE): $(SITE_PACKAGES)/.upgrade
	$(PYTHONUSERBASE) $(PIP) install $(PIP_OPTS) $(PACKAGE)
	touch $@

upgrade: $(SITE_PACKAGES)/.upgrade

install: $(SITE_PACKAGES)/.package-$(PACKAGE)

requirements: $(SITE_PACKAGES)/.requirements

init: requirements

clean:
	pip uninstall -r $(REQUIREMENTS) -y
	[ ! -f $(SITE_PACKAGES)/.package-* ] || rm -fv $(SITE_PACKAGES)/.package-*
	[ ! -f $(SITE_PACKAGES)/.requirements ] || rm -fv $(SITE_PACKAGES)/.requirements
	[ ! -f $(SITE_PACKAGES)/.upgrade ] || rm -fv $(SITE_PACKAGES)/.upgrade

distclean: clean