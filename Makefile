TOPDIR := $(shell pwd)

ARTEFACTS_DIR = $(abspath .artefacts)
DOWNLOAD_URL = https://www.python.org/ftp/python/$(VERSION)/Python-$(VERSION).tgz 
INSTALL_SCHEMA = --user
MAJOR = 3.11
MINOR = 4
OWNER = 
PIP = $(PYTHON) -m pip
PREFIX = $(shell echo ~/.py3/$(VERSION))
PYTHON = $(PREFIX)/bin/python$(MAJOR)
SEVERITY = info
SUDO = $(shell which sudo)
VERSION = $(MAJOR).$(MINOR)

ifdef VARS
    VARS_OPT = VARS=$(realpath $(shell realpath $(VARS)))
else
    VARS_OPT =
endif

ifdef PREFIX
    PREFIX_OPT = --prefix=$(PREFIX)
else
    PREFIX_OPT =
endif

BUILD_OPTS += $(PREFIX_OPT)
BUILD_OPTS += --enable-optimizations

PIP_OPTS += $(INSTALL_SCHEMA)
PIP_OPTS += --break-system-packages
PIP_OPTS += --prefer-binary

TGT_ARTEFACTS_DIR = $(ARTEFACTS_DIR)/.create-dir-$(shell echo $(ARTEFACTS_DIR) | tr '/' '-')
TGT_PREFIX_DIR = $(ARTEFACTS_DIR)/.create-dir-$(shell echo $(PREFIX) | tr '/' '-')

.PHONY: all download build install upgrade configure

all: download build install upgrade configure

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

$(TGT_PREFIX_DIR):
	mkdir -p $(PREFIX)
	touch $@

$(ARTEFACTS_DIR)/Python-$(VERSION).tgz: $(TGT_ARTEFACTS_DIR)
	cd $(ARTEFACTS_DIR) && wget $(DOWNLOAD_URL) && tar -xf Python-$(VERSION).tgz
	touch $@

download: $(ARTEFACTS_DIR)/Python-$(VERSION).tgz

build: $(TGT_PREFIX_DIR)
	cd $(ARTEFACTS_DIR)/Python-$(VERSION) && \
		./configure $(BUILD_OPTS) && \
		make -j $(nproc)

install: $(TGT_PREFIX_DIR)
	cd $(ARTEFACTS_DIR)/Python-$(VERSION) && sudo make altinstall
ifdef OWNER
	$(SUDO) chown -R $(OWNER) $(PREFIX)
endif

upgrade:
	PYTHONUSERBASE=$(PREFIX) $(PIP) install $(PIP_OPTS) --upgrade pip wheel setuptools

configure:
	$(PYTHON) -m pip install -r $(TOPDIR)/render/requirements.txt
	make -f ./configure.mk $(VARS_OPT) all \
		PYTHON=$(PYTHON) \
		SEVERITY=$(SEVERITY)
