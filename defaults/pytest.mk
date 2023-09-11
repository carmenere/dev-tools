pytest__ENABLE ?= $(ENABLE_HOST)
pytest__TAGS ?= test clean
pytest__LOG_FILE ?= $$(SELFDIR)/.logs-$$(notdir $$(SELF))
pytest__REPORTS_DIR ?= $$(SELFDIR)/.reports-$$(notdir $$(SELF))
pytest__TEST_CASES ?= 
pytest__TEST_CASES_DIR ?= tests
pytest__PYTHON ?= $(python__PYTHON)
pytest__MODE ?= shell
pytest__TMUX_START_CMD = $$(MAKE) -f $(TMUX) exec CMD='$$(MAKE) -f $$(OUT) shell' WINDOW_NAME=$$(APP)