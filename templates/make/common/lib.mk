# Use 'abspath' instead 'realpath' because TARGET_DIR is not exists, but 'realpath' checks its existance
# $1:profile,$2:TARGET_DIR,$3:TARGET_ARCH
# EXAMPLE = $(call cargo_bins,dev,target,aarch64-apple-darwin)
define cargo_bins
$(eval 
ifeq ($1,dev)
PROFILE_DIR = debug
else
PROFILE_DIR = $1
endif)$2/$3/$(PROFILE_DIR)
endef

# EXAMPLE = $(call docker_image,ABC,latest)
# EXAMPLE = $(call docker_image,ABC)
define docker_image
$(eval 
ifneq ($2,)
IMAGE = $1:$2
else
IMAGE = $1
endif)$(IMAGE)
endef

# EXAMPLE = $(call docker_image,MAJOR,MINOR)
# EXAMPLE = $(call docker_image,MAJOR)
define version
$(eval 
ifneq ($2,)
VERSION = $1.$2
else
VERSION = $1
endif)$(VERSION)
endef