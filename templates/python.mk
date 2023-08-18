TOPDIR := {{ TOPDIR | default('$(shell pwd)', true) }}

MAJOR ?= {{ MAJOR | default('3.11', true) }}
MINOR ?= {{ MINOR | default('4', true) }}
PYTHON ?= {{ PYTHON | default('$(shell which python$(MAJOR))', true) }}
DOWNLOAD_URL ?= {{ DOWNLOAD_URL | default('https://www.python.org/ftp/python/$(VERSION)/Python-$(VERSION).tgz', true) }} 

VERSION = $(MAJOR).$(MINOR)
PIP = $(PYTHON) -m pip

.PHONY: build

build:
	cd /tmp && \
		wget $(DOWNLOAD_URL) && \
		tar -xf Python-$(VERSION).tgz && \
		cd Python-$(VERSION)/ && \
		./configure --enable-optimizations && \
		make -j $(nproc) && \
		sudo make altinstall
	
	$(PIP) install --upgrade pip
	$(PIP) install --upgrade wheel
	$(PIP) install --upgrade setuptools
