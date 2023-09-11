define LF


endef

# $1:ctx; $2:SCHEMA $3:USER; $4:PASSWORD, $5:HOST, $6:PORT, $7:DB
define conn_url
$(eval 
ifeq ($2,)
x_SCHEMA = example
else
x_SCHEMA = $2
endif
ifeq ($3,)
x_USER = $($(1)__USER_NAME)
else
x_USER = $3
endif
ifeq ($4,)
x_PASSWORD = $($(1)__USER_PASSWORD)
else
x_PASSWORD = $4
endif
ifeq ($5,)
x_HOST = $($(1)__HOST)
else
x_HOST = $5
endif
ifeq ($6,)
x_PORT = $($(1)__PORT)
else
x_PORT = $6
endif
ifeq ($7,)
x_DB = $($(1)__USER_DB)
else
x_DB = $7
endif)$(x_SCHEMA)://$(x_USER):$(x_PASSWORD)@$(x_HOST):$(x_PORT)/$(x_DB)
endef

define uppercase
$(shell echo $1 | tr '[:lower:]' '[:upper:]')
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

# EXAMPLE = $(call docker_image,MAJOR,MINOR)
# EXAMPLE = $(call docker_image,MAJOR)
define version
$(eval 
ifneq ($2,)
x__VERSION = $1.$2
else
x__VERSION = $1
endif)$(x__VERSION)
endef

# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
# $1:profile,$2:TARGET_DIR,$3:TARGET_ARCH
# EXAMPLE = $(call cargo_bins,dev,target,aarch64-apple-darwin)
define cargo_bins
$(eval 
ifeq ($1,dev)
x__PROFILE_DIR = debug
else
x__PROFILE_DIR = $1
endif)$2/$3/$(x__PROFILE_DIR)
endef

# $1:image_name,$2:tag
# EXAMPLE = $(call docker_image,ABC,latest)
# EXAMPLE = $(call docker_image,ABC)
define docker_image
$(eval 
ifneq ($2,)
x__IMAGE = $1:$2
else
x__IMAGE = $1
endif)$(x__IMAGE)
endef

# $1:prefix
# EXAMPLE = $(call list_by_prefix,pg_x__env_)
define list_by_prefix
$(foreach V,$(filter $1%,$(.VARIABLES)),$(subst $1,,$(V)))
endef

# $1:src,$2:dst
# EXAMPLE = $(call copy_ctx,pg_X__env_,pg_Y__env_)
define copy_ctx
$(foreach V,$(filter $1%,$(.VARIABLES)), \
    $(eval $2$(subst $1,,$(V)) = $($(V))) \
)
endef

# $1:src,$2:vars,$3:dst
# EXAMPLE = $(call inherit,pg_X__env,ABC QWERTY,pg_Y__env_)
define inherit_vars
$(foreach V,$2,$(eval $3$(V) ?= $$($1$(V))))
endef

# $1:src,$2:dst
# EXAMPLE = $(call inherit_ctx,pg_X__env_,pg_Y__env_)
define inherit_ctx
$(foreach V,$(filter $1%,$(.VARIABLES)), \
    $(eval $2$(subst $1,,$(V)) ?= $$($(V))) \
)
endef
