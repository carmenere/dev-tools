########################################################################################################################
# pytest_bar
########################################################################################################################
$(call inherit_ctx,pytest__,pytest_bar__)

pytest_bar__IN = $(TMPL_DIR)/pytest.mk
pytest_bar__OUT_DIR = $(OUTDIR)/pytest
pytest_bar__OUT = $(pytest_bar__OUT_DIR)/bar.mk

pytest_bar__TEST_CASES_DIR = $(PROJECT_ROOT)/examples/bar/tests
pytest_bar__PYTHON = $(venv_pytest_bar__OUT_DIR)/.venv/bin/python

pytest_bar__MODE = tmux
pytest_bar__TMUX_START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(pytest_bar__OUT) run' WINDOW_NAME=tests_bar

CTXES += pytest_bar

########################################################################################################################
# pytest_foo
########################################################################################################################
$(call inherit_ctx,pytest__,pytest_foo__)

pytest_foo__IN = $(TMPL_DIR)/pytest.mk
pytest_foo__OUT_DIR = $(OUTDIR)/pytest
pytest_foo__OUT = $(pytest_foo__OUT_DIR)/foo.mk

pytest_foo__TEST_CASES_DIR = $(PROJECT_ROOT)/examples/foo/tests
pytest_foo__PYTHON = $(venv_pytest_foo__OUT_DIR)/.venv/bin/python

CTXES += pytest_foo
