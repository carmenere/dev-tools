# Includes
include $(ARTEFACTS)/.env.pytest

### Targets
.PHONY: default env init run clean clean-venv

default: env

env:
	@echo $(foreach e,$(ENVs),export $(e)=\'$($(e))\'"\n") export ENVs=\'$(ENVs)\'"\n"

$(TARGET_INIT_DIR):
	$(MAKE) -f $(MK)/venv.mk init
	mkdir -p $(PYTEST_ARTEFACTS_DIR)
	touch $@

init: $(TARGET_INIT_DIR)

run: clean init
	$(VENV)/bin/python \
		-m pytest -v $(TEST_CASES) \
		--color=yes

clean:
	[ ! -d $(PYTEST_ARTEFACTS_DIR) ] || rm -Rfv $(PYTEST_ARTEFACTS_DIR)

clean-venv:
	$(MAKE) -f $(MK)/venv.mk clean