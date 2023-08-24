TOPDIR := $(shell pwd)

ARTEFACTS_DIR = $(abspath .artefacts)
DOWNLOAD_URL = https://www.python.org/ftp/python/$(VERSION)/Python-$(VERSION).tgz 
MAJOR = 3.11
MINOR = 4
OWNER = $(USER)
PREFIX = $(shell echo ~/.py3/$(VERSION))
PYTHON = $(PREFIX)/bin/python$(MAJOR)
SEVERITY = info
SUDO = $(shell which sudo)
VERSION = $(MAJOR).$(MINOR)

VENV_DIR = $(ARTEFACTS_DIR)/.venv
VPYTHON = $(VENV_DIR)/bin/python
REQUIREMENTS = $(TOPDIR)/render/requirements.txt

export VARS := $(shell realpath $(VARS))

.PHONY: all python vpython requirements rm-vpython configure

all: python vpython requirements configure

$(PYTHON):
	make -f ./templates/make/py.mk install \
		ARTEFACTS_DIR='$(ARTEFACTS_DIR)' \
		DOWNLOAD_URL='$(DOWNLOAD_URL)' \
		MAJOR='$(MAJOR)' \
		MINOR='$(MINOR)' \
		OWNER='$(OWNER)' \
		PREFIX='$(PREFIX)' \
		SUDO='$(SUDO)' \
		VERSION='$(VERSION)'
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
		ARTEFACTS_DIR='$(VENV_DIR)' \
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

configure: requirements
	make -f ./configure.mk all \
		PYTHON=$(PYTHON) \
		RENDER_PYTHON=$(VPYTHON) \
		SEVERITY=$(SEVERITY)

run: configure
	make -f ./configure.mk run

build:
	make -f ./configure.mk build

venv:
	make -f ./configure.mk venv

pip:
	make -f ./configure.mk pip

apps:
	make -f ./configure.mk apps

schemas:
	make -f ./configure.mk schemas

sysctl:
	make -f ./configure.mk sysctl

tests:
	make -f ./configure.mk tests

tmux:
	make -f ./configure.mk tmux

build:
	make -f ./configure.mk build

docker:
	make -f ./configure.mk docker