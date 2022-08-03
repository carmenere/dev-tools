# Includes
include $(ARTEFACTS)/.env.venv

.PHONY: default env pip poetry clean

default: env

env:
	@echo $(foreach e,$(ENVs),export $(e)=\'$($(e))\'"\n") export ENVs=\'$(ENVs)\'"\n"

$(TARGET_CREATE_VENV):
	$(PYTHONEXECUTABLE) -m venv --prompt="[venv: $(VENV_NAME)]" $(VENV)
	touch $@

$(TARGET_UPGRADE_SETUPTOOLS): $(TARGET_CREATE_VENV)
	$(VENV)/bin/python -m pip install --upgrade pip
	$(VENV)/bin/python -m pip install --upgrade wheel
	$(VENV)/bin/python -m pip install --upgrade setuptools
	touch $@

$(TARGET_INSTALL_POETRY): $(TARGET_UPGRADE_SETUPTOOLS)
	$(VENV)/bin/python -m pip install poetry
	$(VENV)/bin/python -m poetry config virtualenvs.create false
	$(VENV)/bin/python -m poetry config virtualenvs.in-project false
	touch $@

$(TARGET_INSTALL_REQUIREMENTS)-poetry: $(realpath $(VENV_REQUIREMENTS))
	cd $(REQUIREMENTS_DIR) && $(VENV)/bin/python -m poetry install
	touch $@

upgrade-setuptools: $(TARGET_UPGRADE_SETUPTOOLS)

install-poetry: $(TARGET_INSTALL_POETRY)

$(TARGET_INSTALL_REQUIREMENTS)-pip: $(realpath $(VENV_REQUIREMENTS))
	$(VENV)/bin/python -m pip install -r $(realpath $(VENV_REQUIREMENTS))
	touch $@

pip: $(TARGET_INSTALL_REQUIREMENTS)-pip

poetry: $(TARGET_INSTALL_REQUIREMENTS)-poetry

init: upgrade-setuptools
ifeq ($(VENV_PACKAGE_MANAGER),pip)
	$(MAKE) -f $(MK)/venv.mk pip
else ifeq ($(VENV_PACKAGE_MANAGER),poetry)
	$(MAKE) -f $(MK)/venv.mk install-poetry
	$(MAKE) -f $(MK)/venv.mk poetry
endif

clean:
	[ ! -d $(VENV) ] || rm -Rfv $(VENV)