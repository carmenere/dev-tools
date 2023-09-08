# $(and ..., ..., ...) 
# - each argument is expanded, in order;
# - if an argument expands to an empty string the processing stops and the result of the expansion is the empty string;
# - if all arguments expand to a non-empty string then the result of the expansion is the expansion of the last argument;
ifneq ($(strip $(and $(SUDO_BIN),$(SUDO_USER))),)
    SUDO = $(SUDO_BIN) -u $(SUDO_USER)
else ifneq ($(strip $(SUDO_BIN)),)
    SUDO = $(SUDO_BIN)
else
    SUDO = 
endif
