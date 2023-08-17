define LF


endef


define uppercase
$(shell echo $1 | tr '[:lower:]' '[:upper:]')
endef