DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/../..
MK := $(realpath $(DEVTOOLS_DIR)/templates/make)

CC = @CC@
CPPFLAGS = @CPPFLAGS@
CXX = @CXX@
DL = $(abspath @DL@)
INSTALL_SCHEMA = @INSTALL_SCHEMA@
LDFLAGS = @LDFLAGS@
MAJOR = @MAJOR@
MINOR = @MINOR@
RC=@RC@
OWNER = @OWNER@
PREFIX = @PREFIX@
PYTHON = $(abspath @PYTHON@)
REQUIREMENTS = $(abspath @REQUIREMENTS@)
SUDO = @SUDO@
USERBASE = @USERBASE@
VENV_DIR = $(abspath @VENV_DIR@)
VENV_PROMT = @VENV_PROMT@
VPYTHON = $(abspath @VPYTHON@)

.PHONY: init python vpython requirements rm-vpython distclean

init: python vpython requirements

$(PYTHON):
	make -f $(MK)/python.mk install \
		DL='$(DL)' \
		MAJOR='$(MAJOR)' \
		MINOR='$(MINOR)' \
        RC='$(RC)' \
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

requirements: vpython
	make -f $(MK)/pip.mk requirements \
		INSTALL_SCHEMA='$(INSTALL_SCHEMA)' \
		USERBASE='$(USERBASE)' \
		PYTHON='$(VPYTHON)' \
		REQUIREMENTS='$(REQUIREMENTS)' \
		CC='$(CC)' \
		CPPFLAGS='$(CPPFLAGS)' \
		CXX='$(CXX)' \
		LDFLAGS='$(LDFLAGS)'

rm-vpython:
	make -f $(MK)/venv.mk clean VENV_DIR='$(VENV_DIR)'

distclean: rm-vpython
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/config.log
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/aclocal.m4
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/config.status
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/configure~
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/autom4te.cache
