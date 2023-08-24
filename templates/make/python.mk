TOPDIR := {{ TOPDIR }}

ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR }}
DOWNLOAD_URL ?= {{ DOWNLOAD_URL }}
MAJOR ?= {{ MAJOR }}
MINOR ?= {{ MINOR }}
PIP = {{ PIP }}
PREFIX = {{ PREFIX }}
PYTHON ?= {{ PYTHON }}
VERSION ?= {{ VERSION }}

ifdef PREFIX
    PREFIX_OPT = --prefix=$(PREFIX)
else
    PREFIX_OPT =
endif

TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir

.PHONY: build install upgrade

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
