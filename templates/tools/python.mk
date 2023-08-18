TOPDIR := {{ TOPDIR | default('$(shell pwd)', true) }}

MAJOR ?= {{ MAJOR | default('3.11', true) }}
MINOR ?= {{ MINOR | default('4', true) }}
PYTHON ?= {{ PYTHON | default('$(shell which python$(MAJOR))', true) }}
DOWNLOAD_URL ?= {{ DOWNLOAD_URL | default('https://www.python.org/ftp/python/$(VERSION)/Python-$(VERSION).tgz', true) }} 
ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR | default('.artefacts', true) }}
VERSION = $(MAJOR).$(MINOR)
PIP = $(PYTHON) -m pip
PREFIX = {{ PREFIX | default('', true) }}

ifdef PREFIX
    PREFIX_OPT = --prefix=$(PREFIX)
else
    PREFIX_OPT =
endif

TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/create-artefacts-dir

.PHONY: build

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

build: $(TGT_ARTEFACTS_DIR)
	cd $(ARTEFACTS_DIR) && \
		wget $(DOWNLOAD_URL) && \
		tar -xf Python-$(VERSION).tgz && \
		cd Python-$(VERSION)/ && \
		./configure --enable-optimizations  && \
		make -j $(nproc)

install:
	sudo make altinstall
	
upgrade:
	$(PIP) install --upgrade pip
	$(PIP) install --upgrade wheel
	$(PIP) install --upgrade setuptools
