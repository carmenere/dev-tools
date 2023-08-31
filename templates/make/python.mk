# {%- import "common/defaults.j2" as d -%}
SELFDIR := {{ SELFDIR | default(d.SELFDIR, true) }}

DL ?= {{ DL | default('.dl', true)}}
MAJOR ?= {{ MAJOR | default(d.PY_MAJOR, true)}}
MINOR ?= {{ MINOR | default(d.PY_MINOR, true)}}
OWNER ?= {{ OWNER | default(d.PY_OWNER, true)}}
PREFIX ?= {{ PREFIX | default('$(SELFDIR)/.python', true)}}
SUDO_BIN ?= {{ SUDO_BIN | default(d.SUDO_BIN, true) }}

DOWNLOAD_URL = https://www.python.org/ftp/python/$(VERSION)/Python-$(VERSION).tgz 
VERSION ?= $(MAJOR).$(MINOR)
PYTHON ?= $(PREFIX)/bin/python$(MAJOR)

# {% include 'common/sudo.mk' %}

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
