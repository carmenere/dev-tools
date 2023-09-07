########################################################################################################################
# pip_pytest_bar
########################################################################################################################
ENABLE_CTX_pip_pytest_bar = $(ENABLE_ALL_CTXES)
TAG_pip_pytest_bar = pip clean

pip_pytest_bar__APP = tests_bar

pip_pytest_bar__IN = $(MK)/pip.mk
pip_pytest_bar__OUT_DIR = $(OUTDIR)/pip/pytest/bar
pip_pytest_bar__OUT = $(pip_pytest_bar__OUT_DIR)/Makefile

pip_pytest_bar__PYTHON = $(venv_pytest_bar__OUT_DIR)/.venv/bin/python
pip_pytest_bar__REQUIREMENTS = $(PROJECT_ROOT)/examples/bar/tests/requirements.txt

CTXES += pip_pytest_bar

########################################################################################################################
# pip_alembic_baz
########################################################################################################################
ENABLE_CTX_pip_alembic_baz = $(ENABLE_ALL_CTXES)
TAG_pip_alembic_baz = pip clean

pip_alembic_baz__IN = $(MK)/pip.mk
pip_alembic_baz__OUT_DIR = $(OUTDIR)/pip/alembic/baz
pip_alembic_baz__OUT = $(pip_alembic_baz__OUT_DIR)/Makefile

pip_alembic_baz__PYTHON = $(venv_alembic_baz__OUT_DIR)/.venv/bin/python
pip_alembic_baz__REQUIREMENTS = $(PROJECT_ROOT)/examples/baz/migrator/requirements.txt

pip_alembic_baz__CPPFLAGS = -I/opt/homebrew/opt/openssl/include
pip_alembic_baz__LDFLAGS = -L/opt/homebrew/opt/openssl/lib

CTXES += pip_alembic_baz

########################################################################################################################
# pip_pytest_foo
########################################################################################################################
ENABLE_CTX_pip_pytest_foo = $(ENABLE_ALL_CTXES)
TAG_pip_pytest_foo = pip clean

pip_pytest_foo__IN = $(MK)/pip.mk
pip_pytest_foo__OUT_DIR = $(OUTDIR)/pip/pytest/foo
pip_pytest_foo__OUT = $(pip_pytest_foo__OUT_DIR)/Makefile

pip_pytest_foo__PYTHON = $(venv_pytest_foo__OUT_DIR)/.venv/bin/python
pip_pytest_foo__REQUIREMENTS = $(PROJECT_ROOT)/examples/foo/tests/requirements.txt

CTXES += pip_pytest_foo
