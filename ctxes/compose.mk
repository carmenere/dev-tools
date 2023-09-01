# ########################################################################################################################
CTX := compose_example
# ########################################################################################################################
compose_example__IN = $(MK)/compose.mk
compose_example__OUT_DIR = $(d__OUTDIR)/compose
compose_example__OUT = $(compose_example__OUT_DIR)/example.mk

CTXES := $(CTXES) compose_example
