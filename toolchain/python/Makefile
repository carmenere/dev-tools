DEVTOOLS_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST)))/../..)
PY := $(realpath $(DEVTOOLS_DIR)/templates/python)

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
	make -f $(PY)/python.mk install DEVTOOLS_DIR='$(DEVTOOLS_DIR)' DL='$(DL)' \
		MAJOR='$(MAJOR)' MINOR='$(MINOR)' RC='$(RC)' \
		OWNER='$(OWNER)' PREFIX='$(PREFIX)' SUDO='$(SUDO)'

vpython:
	make -f $(PY)/venv.mk init DEVTOOLS_DIR='$(DEVTOOLS_DIR)' \
		PYTHON='$(PYTHON)' VENV_DIR='$(VENV_DIR)' VENV_PROMT='[toolchain]'

requirements:
	make -f $(PY)/pip.mk requirements DEVTOOLS_DIR='$(DEVTOOLS_DIR)' INSTALL_SCHEMA='$(INSTALL_SCHEMA)' \
		USERBASE='$(USERBASE)' PYTHON='$(VPYTHON)' REQUIREMENTS='$(REQUIREMENTS)' \
		CC='$(CC)' CPPFLAGS='$(CPPFLAGS)' CXX='$(CXX)' LDFLAGS='$(LDFLAGS)'

rm-vpython:
	make -f $(PY)/venv.mk clean DEVTOOLS_DIR='$(DEVTOOLS_DIR)' VENV_DIR='$(VENV_DIR)'

clean:
	rm -Rf config.log
	rm -Rf aclocal.m4
	rm -Rf config.status
	rm -Rf configure~
	rm -Rf autom4te.cache
	rm -Rf defaults.mk
	[ ! -d .venv ] || rm -Rf .venv
	rm -Rf Makefile

clean-dl:
	[ ! -d .dl ] || $(SUDO) rm -Rf .dl

distclean:
	$(MAKE) clean-dl
	$(MAKE) clean
