TOPDIR := $(shell pwd)

ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
DOWNLOAD_URL ?= {{ DOWNLOAD_URL }}
MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
OWNER ?= {{ OWNER }}
PREFIX ?= {{ PREFIX }}
SUDO ?= {{ SUDO }}

VERSION ?= $(MAJOR).$(MINOR)
PYTHON ?= $(PREFIX)/bin/python$(MAJOR)

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
ifeq ($(ENABLE_OPTIMIZATIONS),yes)
BUILD_OPTS += --enable-optimizations
endif

.PHONY: all artefacts-dir prefix download build install

all: download build install

artefacts-dir:
	[ -d $(PREFIX) ] || mkdir -p $(ARTEFACTS_DIR)

prefix:
	[ -d $(PREFIX) ] || mkdir -p $(PREFIX)

$(ARTEFACTS_DIR)/Python-$(VERSION).tgz: artefacts-dir
	cd $(ARTEFACTS_DIR) && wget $(DOWNLOAD_URL) && tar -xf Python-$(VERSION).tgz
	touch $@

download: $(ARTEFACTS_DIR)/Python-$(VERSION).tgz

build: download prefix
	cd $(ARTEFACTS_DIR)/Python-$(VERSION) && \
		./configure $(BUILD_OPTS) && \
		make -j $(nproc)

install: build prefix
	cd $(ARTEFACTS_DIR)/Python-$(VERSION) && sudo make altinstall
ifdef OWNER
	$(SUDO) chown -R $(OWNER) $(PREFIX)
endif
	touch $@
