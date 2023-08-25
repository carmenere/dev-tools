DEVTOOLS_DIR ?= $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
TOPDIR := $(shell pwd)
LIB ?= $(DEVTOOLS_DIR)/lib

# Default vars
include $(DEVTOOLS_DIR)/vars/defaults.mk

DL ?= $(abspath .toolchain/.dl)
REQUIREMENTS ?= $(TOPDIR)/render/requirements.txt
SEVERITY ?= info
VENV_DIR ?= $(abspath .toolchain/.venv)
VPYTHON ?= $(VENV_DIR)/bin/python

.PHONY: all python vpython requirements rm-vpython

all: python vpython requirements

$(PYTHON):
	make -f ./templates/make/py.mk install \
		DL='$(DL)' \
		MAJOR='$(PY_MAJOR)' \
		MINOR='$(PY_MINOR)' \
		OWNER='$(PY_OWNER)' \
		PREFIX='$(PY_PREFIX)' \
		SUDO='$(SUDO)'
	touch $@

python: $(PYTHON)

$(VPYTHON): python
	make -f ./templates/make/venv.mk init \
		PYTHON='$(PYTHON)' \
		VENV_DIR='$(VENV_DIR)' \
		VENV_PROMT='[toolchain]'
	touch $@

vpython: $(VPYTHON)

requirements: vpython
	make -f ./templates/make/pip.mk requirements \
		ARTEFACTS_DIR='$(VENV_DIR)/.artefacts' \
		INSTALL_SCHEMA='' \
		USERBASE='' \
		PYTHON='$(VPYTHON)' \
		REQUIREMENTS='$(REQUIREMENTS)' \
		CC='' \
		CPPFLAGS='' \
		CXX='' \
		LDFLAGS='' \

rm-vpython:
	make -f ./templates/make/venv.mk clean \
		PYTHON='$(PYTHON)' \
		VENV_DIR='$(VENV_DIR)' \
		VENV_PROMT='[toolchain]'
