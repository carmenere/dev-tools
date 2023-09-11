########################################################################################################################
# venv_alembic_baz
########################################################################################################################
$(call inherit_ctx,venv__,venv_alembic_baz__)

venv_alembic_baz__IN = $(TMPL_DIR)/python/venv.mk
venv_alembic_baz__OUT_DIR = $(OUTDIR)/python/venv/alembic
venv_alembic_baz__OUT = $(venv_alembic_baz__OUT_DIR)/baz.mk
venv_alembic_baz__VENV_DIR = $(venv_alembic_baz__OUT_DIR)/.venv/baz

CTXES += venv_alembic_baz

########################################################################################################################
# venv_pytest_bar
########################################################################################################################
$(call inherit_ctx,venv__,venv_pytest_bar__)

venv_pytest_bar__IN = $(TMPL_DIR)/python/venv.mk
venv_pytest_bar__OUT_DIR = $(OUTDIR)/python/venv/pytest
venv_pytest_bar__OUT = $(venv_pytest_bar__OUT_DIR)/bar.mk
venv_pytest_bar__VENV_DIR = $(venv_pytest_bar__OUT_DIR)/.venv/bar

CTXES += venv_pytest_bar

########################################################################################################################
# venv_pytest_foo
########################################################################################################################
$(call inherit_ctx,venv__,venv_pytest_foo__)

venv_pytest_foo__IN = $(TMPL_DIR)/python/venv.mk
venv_pytest_foo__OUT_DIR = $(OUTDIR)/python/venv/pytest
venv_pytest_foo__OUT = $(venv_pytest_foo__OUT_DIR)/foo.mk
venv_pytest_foo__VENV_DIR = $(venv_pytest_foo__OUT_DIR)/.venv/foo

venv_pytest_foo__VENV_PROMT = [VENV]

CTXES += venv_pytest_foo
