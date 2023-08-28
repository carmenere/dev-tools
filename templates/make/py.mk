DL ?= {{ DL }}
MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
OWNER ?= {{ OWNER }}
PREFIX ?= {{ PREFIX }}
SUDO ?= {{ SUDO }}

DOWNLOAD_URL = https://www.python.org/ftp/python/$(VERSION)/Python-$(VERSION).tgz 
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

.PHONY: all download build install

all: download build install

$(DL)/Python-$(VERSION).tgz:
	[ -d $(DL) ] || mkdir -p $(DL)
	cd $(DL) && wget $(DOWNLOAD_URL) && tar -xf Python-$(VERSION).tgz
	touch $@

download: $(DL)/Python-$(VERSION).tgz

build: download
	[ -d $(PREFIX) ] || mkdir -p $(PREFIX)
	cd $(DL)/Python-$(VERSION) && \
		./configure $(BUILD_OPTS) && \
		make -j $(nproc)

install: build
	cd $(DL)/Python-$(VERSION) && sudo make altinstall
ifdef OWNER
	$(SUDO) chown -R $(OWNER) $(PREFIX)
endif
