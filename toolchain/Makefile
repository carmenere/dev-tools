DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/..
MK := $(realpath $(DEVTOOLS_DIR)/templates/make)

CC = 
CPPFLAGS = 
CXX = 
DL = $(abspath .dl)
INSTALL_SCHEMA = 
LDFLAGS = 
MAJOR = 3.11
MINOR = 4
OWNER = an.romanov
PREFIX = /Users/an.romanov/.py/3.11.4
PYTHON = $(abspath /Users/an.romanov/.py/3.11.4/bin/python3.11)
REQUIREMENTS = $(abspath ../render/requirements.txt)
SUDO = /usr/bin/sudo
USERBASE = 
VENV_DIR = $(abspath /Users/an.romanov/Projects/ololo/dev-tools/toolchain/.venv)
VENV_PROMT = toolchain
VPYTHON = $(abspath /Users/an.romanov/Projects/ololo/dev-tools/toolchain/.venv/bin/python)

SITE_PACKAGES = $(shell $(PYTHON) -m pip show pip | grep Location | cut -d':' -f 2)

.PHONY: init python vpython requirements rm-vpython distclean

init: python vpython requirements

$(PYTHON):
	make -f $(MK)/py.mk install \
		DL='$(DL)' \
		MAJOR='$(MAJOR)' \
		MINOR='$(MINOR)' \
		OWNER='$(OWNER)' \
		PREFIX='$(PREFIX)' \
		SUDO='$(SUDO)'
	touch $@

python: $(PYTHON)

$(VPYTHON): python
	make -f $(MK)/venv.mk init \
		PYTHON='$(PYTHON)' \
		VENV_DIR='$(VENV_DIR)' \
		VENV_PROMT='[toolchain]'
	touch $@

vpython: $(VPYTHON)

$(SITE_PACKAGES)/.requirements: vpython
	make -f $(MK)/pip.mk requirements \
		INSTALL_SCHEMA='$(INSTALL_SCHEMA)' \
		USERBASE='$(USERBASE)' \
		PYTHON='$(VPYTHON)' \
		REQUIREMENTS='$(REQUIREMENTS)' \
		CC='$(CC)' \
		CPPFLAGS='$(CPPFLAGS)' \
		CXX='$(CXX)' \
		LDFLAGS='$(LDFLAGS)'
	touch $@

requirements: $(SITE_PACKAGES)/.requirements

rm-vpython:
	make -f $(MK)/venv.mk clean VENV_DIR='$(VENV_DIR)'

distclean: rm-vpython
	rm -Rf $(TOPDIR)/config.log
	rm -Rf $(TOPDIR)/aclocal.m4
	rm -Rf $(TOPDIR)/config.status
	rm -Rf $(TOPDIR)/configure~
	rm -Rf $(TOPDIR)/autom4te.cache
