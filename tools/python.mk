TOPDIR = {{ TOPDIR | default('$(shell pwd)')}}
MAJOR ?= {{ MAJOR | default('3.11') }}
VERSION ?= $(MAJOR).{{ MINOR | default('4') }}
PYTHON ?= {{ PYTHON | default('python$(MAJOR)') }}
DOWNLOAD_URL ?= {{DOWNLOAD_URL | default('https://www.python.org/ftp/python/$(VERSION)/Python-$(VERSION).tgz') }} 
VENV_PROMT = {{ VENV_PROMT | default('[venv]') }}
VENV_DIR = {{ VENV_DIR | default('$(TOPDIR)/.venv') }}
VPYTHON = {{ VPYTHON | default('$(VENV_DIR)/bin/python') }}
REQUIREMENTS = {{ REQUIREMENTS | default('requirements.txt') }}

.PHONY: build venv

build:
	cd /tmp && \
		wget $(DOWNLOAD_URL) && \
		tar -xf Python-$(VERSION).tgz && \
		cd Python-$(VERSION)/ && \
		./configure --enable-optimizations && \
		make -j $(nproc) && \
		sudo make altinstall
	
	$(PYTHON) -m pip install --upgrade pip
	$(PYTHON) -m pip install --upgrade wheel
	$(PYTHON) -m pip install --upgrade setuptools

venv:
	$(PYTHON) -m venv --prompt=$(VENV_PROMT) $(VENV_DIR)
	$(VPYTHON) -m pip install --prefer-binary -r $(REQUIREMENTS)
