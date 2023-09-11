########################################################################################################################
# pip_pytest_bar
########################################################################################################################
$(call inherit_ctx,pip__,pip_pytest_bar__)

pip_pytest_bar__APP = tests_bar

pip_pytest_bar__IN = $(TMPL_DIR)/python/pip.mk
pip_pytest_bar__OUT_DIR = $(OUTDIR)/python/pip/pytest
pip_pytest_bar__OUT = $(pip_pytest_bar__OUT_DIR)/bar.mk

pip_pytest_bar__PYTHON = $(venv_pytest_bar__VENV_DIR)/bin/python
pip_pytest_bar__REQUIREMENTS = $(PROJECT_ROOT)/examples/bar/tests/requirements.txt

CTXES += pip_pytest_bar

########################################################################################################################
# pip_alembic_baz
########################################################################################################################
$(call inherit_ctx,pip__,pip_alembic_baz__)

pip_alembic_baz__IN = $(TMPL_DIR)/python/pip.mk
pip_alembic_baz__OUT_DIR = $(OUTDIR)/python/pip/alembic
pip_alembic_baz__OUT = $(pip_alembic_baz__OUT_DIR)/baz.mk

pip_alembic_baz__PYTHON = $(venv_alembic_baz__VENV_DIR)/bin/python
pip_alembic_baz__REQUIREMENTS = $(PROJECT_ROOT)/examples/baz/migrator/requirements.txt

pip_alembic_baz__CPPFLAGS = -I/opt/homebrew/opt/openssl/include
pip_alembic_baz__LDFLAGS = -L/opt/homebrew/opt/openssl/lib

CTXES += pip_alembic_baz

########################################################################################################################
# pip_pytest_foo
########################################################################################################################
$(call inherit_ctx,pip__,pip_pytest_foo__)

pip_pytest_foo__IN = $(TMPL_DIR)/python/pip.mk
pip_pytest_foo__OUT_DIR = $(OUTDIR)/python/pip/pytest
pip_pytest_foo__OUT = $(pip_pytest_foo__OUT_DIR)/foo.mk

pip_pytest_foo__PYTHON = $(venv_pytest_foo__VENV_DIR)/bin/python
pip_pytest_foo__REQUIREMENTS = $(PROJECT_ROOT)/examples/foo/tests/requirements.txt

CTXES += pip_pytest_foo
