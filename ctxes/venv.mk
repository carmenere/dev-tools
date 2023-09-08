########################################################################################################################
# venv_alembic_baz
########################################################################################################################
ENABLE_CTX_venv_alembic_baz = $(ENABLE_ALL_CTXES)
TAG_venv_alembic_baz = venv clean

venv_alembic_baz__IN = $(TMPL_DIR)/python/venv.mk
venv_alembic_baz__OUT_DIR = $(OUTDIR)/python/venv/alembic
venv_alembic_baz__OUT = $(venv_alembic_baz__OUT_DIR)/baz.mk
venv_alembic_baz__VENV_DIR = $(venv_alembic_baz__OUT_DIR)/.venv/baz

CTXES += venv_alembic_baz

########################################################################################################################
# venv_pytest_bar
########################################################################################################################
ENABLE_CTX_venv_pytest_bar = $(ENABLE_ALL_CTXES)
TAG_venv_pytest_bar = venv clean

venv_pytest_bar__IN = $(TMPL_DIR)/python/venv.mk
venv_pytest_bar__OUT_DIR = $(OUTDIR)/python/venv/pytest
venv_pytest_bar__OUT = $(venv_pytest_bar__OUT_DIR)/bar.mk
venv_pytest_bar__VENV_DIR = $(venv_pytest_bar__OUT_DIR)/.venv/bar

CTXES += venv_pytest_bar

########################################################################################################################
# venv_pytest_foo
########################################################################################################################
ENABLE_CTX_venv_pytest_foo = $(ENABLE_ALL_CTXES)
TAG_venv_pytest_foo = venv clean

venv_pytest_foo__IN = $(TMPL_DIR)/python/venv.mk
venv_pytest_foo__OUT_DIR = $(OUTDIR)/python/venv/pytest
venv_pytest_foo__OUT = $(venv_pytest_foo__OUT_DIR)/foo.mk
venv_pytest_foo__VENV_DIR = $(venv_pytest_foo__OUT_DIR)/.venv/foo

venv_pytest_foo__VENV_PROMT = [VENV]

CTXES += venv_pytest_foo
