########################################################################################################################
CTX := pytest_bar
########################################################################################################################
ctx_pytest_bar__ENABLED = yes
ctx_pytest_bar__STAGE = tests

pytest_bar__IN = $(MK)/pytest.mk
pytest_bar__OUT_DIR = $(d__OUTDIR)/pytest/bar
pytest_bar__OUT = $(pytest_bar__OUT_DIR)/Makefile

pytest_bar__TEST_CASES_DIR = $(d__PROJECT_ROOT)/examples/bar/tests
pytest_bar__PYTHON = $(venv_pytest_bar__OUT_DIR)/.venv/bin/python

pytest_bar__MODE = tmux
pytest_bar__TMUX_START_CMD = make -f $(tmux__OUT) exec CMD='$(MAKE) -f $(pytest_bar__OUT) run' WINDOW_NAME=tests_bar

pytest_bar__ENVS = 

CTXES := $(CTXES) pytest_bar

########################################################################################################################
CTX := pytest_foo
########################################################################################################################
ctx_pytest_foo__ENABLED = yes
ctx_pytest_foo__STAGE = tests

pytest_foo__IN = $(MK)/pytest.mk
pytest_foo__OUT_DIR = $(d__OUTDIR)/pytest/foo
pytest_foo__OUT = $(pytest_foo__OUT_DIR)/Makefile

pytest_foo__TEST_CASES_DIR = $(d__PROJECT_ROOT)/examples/foo/tests
pytest_foo__PYTHON = $(venv_pytest_foo__OUT_DIR)/.venv/bin/python

pytest_foo__ENVS = 

CTXES := $(CTXES) pytest_foo
