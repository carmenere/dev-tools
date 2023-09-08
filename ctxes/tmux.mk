########################################################################################################################
# tmux
########################################################################################################################
ENABLE_CTX_tmux = $(ENABLE_ALL_CTXES)
TAG_tmux = tmux clean init

tmux__IN = $(TMPL_DIR)/tmux.mk
tmux__OUT_DIR = $(OUTDIR)/tmux
tmux__OUT = $(tmux__OUT_DIR)/tmux.mk

CTXES += tmux
