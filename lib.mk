define LF


endef

# $1:SCHEMA $2:USER; $3:PASSWORD, $4:HOST, $5:PORT, $6:DB
define conn_url
$(eval 
ifneq ($1,)
x_SCHEMA = $1
else
x_SCHEMA = postgres
endif
ifneq ($2,)
x_USER = $2
else
x_USER = $(SERVICE_USER)
endif
ifneq ($3,)
x_PASSWORD = $3
else
x_PASSWORD = $(SERVICE_PASSWORD)
endif
ifneq ($4,)
x_HOST = $4
else
x_HOST = $(PG_HOST)
endif
ifneq ($5,)
x_PORT = $5
else
x_PORT = $(PG_PORT)
endif
ifneq ($6,)
x_DB = $6
else
x_DB = $(SERVICE_DB)
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
