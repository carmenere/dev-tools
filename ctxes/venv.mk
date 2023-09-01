########################################################################################################################
CTX := venv_alembic_baz
########################################################################################################################
ctx_venv_alembic_baz__ENABLED = yes
ctx_venv_alembic_baz__STAGE = venvs

venv_alembic_baz__IN = $(MK)/venv.mk
venv_alembic_baz__OUT_DIR = $(d__OUTDIR)/venv/alembic/baz
venv_alembic_baz__OUT = $(venv_alembic_baz__OUT_DIR)/Makefile

CTXES := $(CTXES) venv_alembic_baz

########################################################################################################################
CTX := venv_pytest_bar
########################################################################################################################
ctx_venv_pytest_bar__ENABLED = yes
ctx_venv_pytest_bar__STAGE = venvs

venv_pytest_bar__IN = $(MK)/venv.mk
venv_pytest_bar__OUT_DIR = $(d__OUTDIR)/venv/pytest/bar
venv_pytest_bar__OUT = $(venv_pytest_bar__OUT_DIR)/Makefile

CTXES := $(CTXES) venv_pytest_bar

########################################################################################################################
CTX := venv_pytest_foo
########################################################################################################################
ctx_venv_pytest_foo__ENABLED = yes
ctx_venv_pytest_foo__STAGE = venvs

venv_pytest_foo__IN = $(MK)/venv.mk
venv_pytest_foo__OUT_DIR = $(d__OUTDIR)/venv/pytest/foo
venv_pytest_foo__OUT = $(venv_pytest_foo__OUT_DIR)/Makefile

venv_pytest_foo__VENV_PROMT = [VENV]

CTXES := $(CTXES) venv_pytest_foo
