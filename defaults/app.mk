app__ENABLE ?= $(ENABLE_HOST)
app__TAGS ?= clean app
app__APP ?= foo
app__BIN_PATH ?= /dev/zero
app__LOG_FILE ?= $$(SELFDIR)/.logs-$$(APP)
app__MODE ?= shell
app__OUT ?= /dev/null
app__PID_FILE ?= $$(SELFDIR)/.pid-$$(APP)
app__PKILL_PATTERN ?= $$(BIN_PATH)
app__TMUX ?= $(tmux__OUT)
app__TMUX_START_CMD ?= $$(MAKE) -f $$(TMUX) exec CMD='$$(MAKE) -f $$(OUT) shell' WINDOW_NAME=$$(APP)
