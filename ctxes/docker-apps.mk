########################################################################################################################
# docker_rust
########################################################################################################################
ENABLE_docker_rust = $(ENABLE_DOCKER_APPS)
docker_rust__STAGE = images docker-rm

docker_rust__IN = $(MK)/docker.mk
docker_rust__OUT_DIR = $(OUTDIR)/docker
docker_rust__OUT = $(docker_rust__OUT_DIR)/rust.mk

docker_rust__CONTAINER = builder_rust
docker_rust__CTX = $(PROJECT_ROOT)
docker_rust__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust
docker_rust__TAG = latest
docker_rust__IMAGE = $(call docker_image,toolchain,$(docker_rust__TAG))

# docker build_args
docker_rust__arg_BASE_IMAGE = $(DOCKER_ALPINE_IMAGE)
docker_rust__arg_RUST_VERSION = $(DOCKER_RUST_VERSION)
docker_rust__arg_TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)
docker_rust__arg_SQLX_VERSION = 0.7.1

CTXES += docker_rust

########################################################################################################################
# docker_bar
########################################################################################################################
ENABLE_docker_bar = $(ENABLE_DOCKER_APPS)
docker_bar__STAGE = images docker-apps docker-rm

docker_bar__IN = $(MK)/docker.mk
docker_bar__OUT_DIR = $(OUTDIR)/docker
docker_bar__OUT = $(docker_bar__OUT_DIR)/bar.mk

docker_bar__CONTAINER = bar
docker_bar__CTX = $(PROJECT_ROOT)
docker_bar__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_bar__PUBLISH = 8081:80/tcp
docker_bar__TAG = bar
docker_bar__IMAGE = $(call docker_image,app,$(docker_bar__TAG))

docker_bar__COMMAND = $(INSTALL_DIR)/bar $$(OPTS)

# docker build_args
docker_bar__arg_APP = bar
docker_bar__arg_BUILDER = $(docker_rust__IMAGE)
docker_bar__arg_BUILD_PROFILE = $(CARGO_PROFILE)
docker_bar__arg_BUILD_VERSION = $(BUILD_VERSION)
docker_bar__arg_TARGET_ARCH = $(DOCKER_RUST_TARGET_ARCH)
docker_bar__arg_BASE_IMAGE = $(DOCKER_ALPINE_IMAGE)

# docker envs
$(call inherit_ctx,bar__env_,docker_bar__env_)

CTXES += docker_bar

########################################################################################################################
# docker_foo
########################################################################################################################
ENABLE_docker_foo = $(ENABLE_DOCKER_APPS)
docker_foo__STAGE = images docker-apps docker-rm

docker_foo__IN = $(MK)/docker.mk
docker_foo__OUT_DIR = $(OUTDIR)/docker
docker_foo__OUT = $(docker_foo__OUT_DIR)/foo.mk

docker_foo__CONTAINER = foo
docker_foo__CTX = $(PROJECT_ROOT)
docker_foo__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_foo__PUBLISH = 9081:80/tcp
docker_foo__TAG = foo
docker_foo__IMAGE = $(call docker_image,app,$(docker_foo__TAG))

docker_foo__COMMAND = $(INSTALL_DIR)/foo $$(OPTS)

# docker build_args
$(call copy_ctx,docker_bar__arg_,docker_foo__arg_)
docker_foo__arg_APP = foo

# # docker envs
$(call inherit_ctx,foo__env_,docker_foo__env_)

CTXES += docker_foo

########################################################################################################################
# docker_sqlx_bar
########################################################################################################################
ENABLE_docker_sqlx_bar = $(ENABLE_SCHEMAS)
docker_sqlx_bar__STAGE = schemas docker-rm

docker_sqlx_bar__IN = $(MK)/docker.mk
docker_sqlx_bar__OUT_DIR = $(OUTDIR)/docker/sqlx
docker_sqlx_bar__OUT = $(docker_sqlx_bar__OUT_DIR)/bar.mk

docker_sqlx_bar__CONTAINER = sqlx_bar
docker_sqlx_bar__CTX = $(PROJECT_ROOT)
docker_sqlx_bar__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust
docker_sqlx_bar__IMAGE = $(docker_rust__IMAGE)

docker_sqlx_bar__COMMAND = $(BASH) -c $$$$'$(call escape,/$$$${HOME}/.cargo/bin/sqlx migrate run $$(OPTS))'

# sqlx envs
$(call inherit_ctx,bar__env_,docker_sqlx_bar__env_)
docker_sqlx_bar__env_DATABASE_URL = $(call pg_db_url,,,$(docker_pg__CONTAINER),,bar)

# sqlx cli opts
$(call inherit_ctx,bar__opt_,docker_sqlx_bar__opt_)
docker_sqlx_bar__opt_SOURCE = --source "/opt/dev-tools/examples/bar/$(SCHEMAS_DIR)"

# docker build_args
$(call copy_ctx,docker_bar__arg_,docker_sqlx_bar__arg_)
docker_sqlx_bar__arg_APP = sqlx_bar

CTXES += docker_sqlx_bar

########################################################################################################################
# docker_sqlx_foo
########################################################################################################################
ENABLE_docker_sqlx_foo = $(ENABLE_SCHEMAS)
docker_sqlx_foo__STAGE = schemas docker-rm

docker_sqlx_foo__APP = docker_sqlx_foo

docker_sqlx_foo__IN = $(MK)/docker.mk
docker_sqlx_foo__OUT_DIR = $(OUTDIR)/docker/sqlx
docker_sqlx_foo__OUT = $(docker_sqlx_foo__OUT_DIR)/foo.mk

docker_sqlx_foo__CONTAINER = sqlx_foo
docker_sqlx_foo__CTX = $(PROJECT_ROOT)
docker_sqlx_foo__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust
docker_sqlx_foo__IMAGE = $(docker_rust__IMAGE)

docker_sqlx_foo__COMMAND = $(BASH) -c $$$$'$(call escape,/$$$${HOME}/.cargo/bin/sqlx migrate run $$(OPTS))'

# sqlx envs
$(call inherit_ctx,foo__env_,docker_sqlx_foo__env_)
docker_sqlx_foo__env_DATABASE_URL = $(call pg_db_url,,,$(docker_pg__CONTAINER),,foo)

# sqlx cli opts
$(call inherit_ctx,foo__opt_,docker_sqlx_foo__opt_)
docker_sqlx_foo__opt_SOURCE = --source "/opt/dev-tools/examples/foo/$(SCHEMAS_DIR)"

# docker build_args
$(call copy_ctx,docker_foo__arg_,docker_sqlx_foo__arg_)
docker_sqlx_foo__arg_APP = sqlx_foo

CTXES += docker_sqlx_foo