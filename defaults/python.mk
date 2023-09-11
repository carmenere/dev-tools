PYTHON ?= $(shell which python3)
# toolchain's python
TPYTHON ?= $(PYTHON)

# python
python__ENABLE = $(ENABLE_HOST)
python__DL ?= .dl
python__DOWNLOAD_URL = https://www.python.org/ftp/python/$(python__MAJOR).$(python__MINOR)/Python-$(python__VERSION).tgz 
python__MAJOR ?= 3.11
python__MINOR ?= 4
python__RC ?=
python__OWNER ?= $(USER)
python__PREFIX ?= $$(SELFDIR)/.python
python__PYTHON ?= $(python__PREFIX)/bin/python$(python__MAJOR)
python__SUDO_BIN ?= $(SUDO_BIN)
python__SUDO_USER ?= $(SUDO_USER)
python__VERSION ?= $(python__MAJOR).$(python__MINOR)$(RC)

# venv
venv__ENABLE = $(ENABLE_HOST)
venv__TAGS = venv clean
venv__PYTHON ?= $(python__PYTHON)
venv__VENV_DIR ?= $$(SELFDIR)/.venv/$$(notdir $$(SELF))
venv__VENV_PROMT ?= [venv]

# pip
pip__ENABLE = $(ENABLE_HOST)
pip__CC = $(CC)
pip__CPPFLAGS = $(CPPFLAGS)
pip__CXX = $(CXX)
pip__LDFLAGS = $(LDFLAGS)
pip__PYTHON ?= $(python__PYTHON)
pip__REQUIREMENTS ?= requirements.txt
pip__TAGS = pip
pip__INSTALL_SCHEMA = 
pip__USERBASE =
