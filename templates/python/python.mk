SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
SELFDIR = $(realpath $(dir $(SELF)))
DEVTOOLS_DIR ?= {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

DL ?= {{ DL }}
MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
RC ?= {{ RC }}
OWNER ?= {{ OWNER }}
PREFIX ?= {{ PREFIX }}

DOWNLOAD_URL = https://www.python.org/ftp/python/$(MAJOR).$(MINOR)/Python-$(VERSION).tgz 
VERSION ?= $(MAJOR).$(MINOR)$(RC)
PYTHON ?= $(PREFIX)/bin/python$(MAJOR)

# SUDO
SUDO_BIN ?= {{ SUDO_BIN }}
SUDO_USER ?= {{ SUDO_USER }}
include $(DEVTOOLS_DIR)/templates/common/sudo.mk

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

.PHONY: all download build install

all: download build install

$(DL)/Python-$(VERSION).tgz:
	[ -d $(DL) ] || mkdir -p $(DL)
	cd $(DL) && wget $(DOWNLOAD_URL) && tar -xf Python-$(VERSION).tgz

download: $(DL)/Python-$(VERSION).tgz

$(DL)/Python-$(VERSION)/python.exe: $(DL)/Python-$(VERSION).tgz
	[ -d $(PREFIX) ] || mkdir -p $(PREFIX)
	cd $(DL)/Python-$(VERSION) && \
		./configure $(BUILD_OPTS) && \
		make -j $(nproc)

build: $(DL)/Python-$(VERSION)/python.exe

$(PREFIX)/bin/python$(MAJOR): $(DL)/Python-$(VERSION)/python.exe
	cd $(DL)/Python-$(VERSION) && sudo make altinstall
ifdef OWNER
	$(SUDO) chown -R $(OWNER) $(PREFIX)
endif

install: $(PREFIX)/bin/python$(MAJOR)