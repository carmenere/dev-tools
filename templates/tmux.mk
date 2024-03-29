SELF := $(realpath $(lastword $(MAKEFILE_LIST)))
SELFDIR = $(realpath $(dir $(SELF)))
DEVTOOLS_DIR := {{ DEVTOOLS_DIR }}

include $(DEVTOOLS_DIR)/lib.mk

DEFAULT_CMD ?= {{ DEFAULT_CMD }}
DEFAULT_TERM ?= {{ DEFAULT_TERM }}
HISTORY_LIMIT ?= {{ HISTORY_LIMIT }}
LOGS_DIR ?= {{ LOGS_DIR }}
SESSION_NAME ?= {{ SESSION_NAME }}
TERM_SIZE ?= {{ TERM_SIZE }}

CMD ?= 
WINDOW_NAME ?= 

.PHONY: init open-window exec close-window close-session kill-server connect

init:
	tmux has-session -t $(SESSION_NAME) || tmux new -s $(SESSION_NAME) -d
	tmux has-session -t $(SESSION_NAME) && \
		tmux set-option -t $(SESSION_NAME) -g default-command '$(DEFAULT_CMD)'
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

stop: kill

kill:
	tmux kill-server || true

connect:
ifdef WINDOW_NAME
	tmux a -t $(SESSION_NAME):$(WINDOW_NAME)
else
	tmux a -t $(SESSION_NAME)
endif

clean: kill

distclean: clean
