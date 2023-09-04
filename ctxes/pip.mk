########################################################################################################################
# pip_pytest_bar
########################################################################################################################
ctx_pip_pytest_bar__ENABLED = no
ctx_pip_pytest_bar__STAGE = pip

pip_pytest_bar__APP = tests_bar

pip_pytest_bar__IN = $(MK)/pip.mk
pip_pytest_bar__OUT_DIR = $(d__OUTDIR)/pip/pytest/bar
pip_pytest_bar__OUT = $(pip_pytest_bar__OUT_DIR)/Makefile

pip_pytest_bar__PYTHON = $(venv_pytest_bar__OUT_DIR)/.venv/bin/python
pip_pytest_bar__REQUIREMENTS = $(d__PROJECT_ROOT)/examples/bar/tests/requirements.txt

CTXES += pip_pytest_bar

########################################################################################################################
# pip_alembic_baz
########################################################################################################################
ctx_pip_alembic_baz__ENABLED = no
ctx_pip_alembic_baz__STAGE = pip

pip_alembic_baz__IN = $(MK)/pip.mk
pip_alembic_baz__OUT_DIR = $(d__OUTDIR)/pip/alembic/baz
pip_alembic_baz__OUT = $(pip_alembic_baz__OUT_DIR)/Makefile

pip_alembic_baz__PYTHON = $(venv_alembic_baz__OUT_DIR)/.venv/bin/python
pip_alembic_baz__REQUIREMENTS = $(d__PROJECT_ROOT)/examples/baz/migrator/requirements.txt

CTXES += pip_alembic_baz

########################################################################################################################
# pip_pytest_foo
########################################################################################################################
ctx_pip_pytest_foo__ENABLED = no
ctx_pip_pytest_foo__STAGE = pip

pip_pytest_foo__IN = $(MK)/pip.mk
pip_pytest_foo__OUT_DIR = $(d__OUTDIR)/pip/pytest/foo
pip_pytest_foo__OUT = $(pip_pytest_foo__OUT_DIR)/Makefile

pip_pytest_foo__PYTHON = $(venv_pytest_foo__OUT_DIR)/.venv/bin/python
pip_pytest_foo__REQUIREMENTS = $(d__PROJECT_ROOT)/examples/foo/tests/requirements.txt

CTXES += pip_pytest_foo
