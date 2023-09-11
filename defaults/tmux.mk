tmux__ENABLE = $(ENABLE_HOST)
tmux__DEFAULT_CMD ?= $(SH)
tmux__DEFAULT_TERM ?= xterm-256color
tmux__HISTORY_LIMIT ?= 1000000
tmux__LOGS_DIR ?= $$(SELFDIR)/.logs-$(tmux__SESSION_NAME)
tmux__SESSION_NAME ?= DEV-TOOLS
tmux__TERM_SIZE ?= 240x32
tmux__TAGS = tmux clean init