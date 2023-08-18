ARTEFACTS_DIR ?= {{ ARTEFACTS_DIR | default('.artefacts', true) }}
DEFAULT_CMD ?= {{ DEFAULT_CMD | default('/bin/sh', true) }}
LOGS_DIR ?= {{ DEFAULT_CMD | default('$(ARTEFACTS_DIR)', true) }}
SESSION_NAME ?= {{ SESSION_NAME | default('DEV-TOOLS', true) }}
TERM_SIZE ?= {{ TERM_SIZE | default('240x32', true) }}
DEFAULT_TERM ?= {{ DEFAULT_TERM | default('xterm-256color', true) }}
HISTORY_LIMIT ?= {{ HISTORY_LIMIT | default('1000000', true) }}

CMD ?= 
WINDOW_NAME ?= 

# Targets
TGT_ARTEFACTS_DIR ?= $(ARTEFACTS_DIR)/.create-artefacts-dir

.PHONY: init open-window exec close-window close-session kill-server extract-logs connect log

$(TGT_ARTEFACTS_DIR):
	mkdir -p $(ARTEFACTS_DIR)
	touch $@

init: $(TGT_ARTEFACTS_DIR)
	tmux has-session -t $(SESSION_NAME) || tmux new -s $(SESSION_NAME) -d
	tmux has-session -t $(SESSION_NAME) && \
		tmux set-option -t $(SESSION_NAME) -g default-command $(DEFAULT_CMD)
	tmux has-session -t $(SESSION_NAME) && \
		tmux set-option -t $(SESSION_NAME) -g default-terminal $(DEFAULT_TERM)
	tmux has-session -t $(SESSION_NAME) && \
		tmux set-option -t $(SESSION_NAME) -g history-limit $(HISTORY_LIMIT)
	tmux has-session -t $(SESSION_NAME) && \
		tmux set-option -t $(SESSION_NAME) -g default-size $(TERM_SIZE)

open-window:
	tmux select-window -t $(SESSION_NAME):$(WINDOW_NAME) || tmux new-window -t $(SESSION_NAME) -n $(WINDOW_NAME)

exec: open-window
	tmux send-keys -t $(SESSION_NAME):$(WINDOW_NAME) "$(CMD)" ENTER

close-window:
	tmux has-session -t $(SESSION_NAME) && tmux kill-window -t $(SESSION_NAME):$(WINDOW_NAME) || echo "Window $(SESSION_NAME):$(WINDOW_NAME) was not opened."

close-session:
	tmux has-session -t $(SESSION_NAME) && tmux kill-session -t $(SESSION_NAME) || echo "Session $(SESSION_NAME) was not opened."

kill-server:
	tmux kill-server || true

extract-logs:
	mv $(ARTEFACTS_DIR)/apps/*.log $(LOGS_DIR)

connect:
ifdef WINDOW_NAME
	tmux a -t $(SESSION_NAME):$(WINDOW_NAME)
else
	tmux a -t $(SESSION_NAME)
endif

log:
	tmux select-window -t $(SESSION_NAME):$(WINDOW_NAME) && tmux capture-pane -t $(SESSION_NAME):$(WINDOW_NAME) -b $(WINDOW_NAME)_buf -S - || echo "echo 'Window $(WINDOW_NAME) does not exist.'"
	tmux select-window -t $(SESSION_NAME):$(WINDOW_NAME) && tmux save-buffer -b $(WINDOW_NAME)_buf $(ARTEFACTS_DIR)/$(WINDOW_NAME).log || echo "echo 'Window $(WINDOW_NAME) does not exist.'"
