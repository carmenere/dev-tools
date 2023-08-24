define LF


endef

define uppercase
$(shell echo $1 | tr '[:lower:]' '[:upper:]')
endef

define lowercase
$(shell echo $1 | tr '[:upper:]' '[:lower:]')
endef

define lowercase
$(shell echo $1 | tr '[:upper:]' '[:lower:]')
endef

define escape
$(subst ",\",$(subst ',\',$1))
endef

define escape2
$(subst \n,\\\\n,$(subst ",\",$(subst ',\',$1)))
endef
