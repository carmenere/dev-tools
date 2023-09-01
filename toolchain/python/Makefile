DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
MK := $(realpath $(DEVTOOLS_DIR)/templates/make)

CC = 
CPPFLAGS = 
CXX = 
DL = $(abspath .dl)
INSTALL_SCHEMA = 
LDFLAGS = 
MAJOR = 3.11
MINOR = 4
RC=
OWNER = an.romanov
PREFIX = /Users/an.romanov/.py/3.11.4
PYTHON = $(abspath /Users/an.romanov/.py/3.11.4/bin/python3.11)
REQUIREMENTS = $(abspath /Users/an.romanov/Projects/ololo/dev-tools/toolchain/python/../../render/requirements.txt)
SUDO = /usr/bin/sudo
USERBASE = 
VENV_DIR = $(abspath /Users/an.romanov/Projects/ololo/dev-tools/toolchain/python/.venv/3.11.4)
VENV_PROMT = toolchain
VPYTHON = $(abspath /Users/an.romanov/Projects/ololo/dev-tools/toolchain/python/.venv/3.11.4/bin/python)

.PHONY: all python vpython requirements rm-vpython distclean

all: python vpython requirements

python:
	make -f $(MK)/python.mk install DEVTOOLS_DIR='$(DEVTOOLS_DIR)' DL='$(DL)' \
		MAJOR='$(MAJOR)' MINOR='$(MINOR)' RC='$(RC)' \
		OWNER='$(OWNER)' PREFIX='$(PREFIX)' SUDO='$(SUDO)'

vpython:
	make -f $(MK)/venv.mk init DEVTOOLS_DIR='$(DEVTOOLS_DIR)' \
		PYTHON='$(PYTHON)' VENV_DIR='$(VENV_DIR)' VENV_PROMT='[toolchain]'

requirements:
	make -f $(MK)/pip.mk requirements DEVTOOLS_DIR='$(DEVTOOLS_DIR)' INSTALL_SCHEMA='$(INSTALL_SCHEMA)' \
		USERBASE='$(USERBASE)' PYTHON='$(VPYTHON)' REQUIREMENTS='$(REQUIREMENTS)' \
		CC='$(CC)' CPPFLAGS='$(CPPFLAGS)' CXX='$(CXX)' LDFLAGS='$(LDFLAGS)'

rm-vpython:
	make -f $(MK)/venv.mk clean VENV_DIR='$(VENV_DIR)'

distclean: rm-vpython
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/config.log
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/aclocal.m4
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/config.status
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/configure~
	rm -Rf $(DEVTOOLS_DIR)/toolchain/python/autom4te.cache
