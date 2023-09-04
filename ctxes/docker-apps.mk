########################################################################################################################
# docker_rust
########################################################################################################################
ctx_docker_rust__ENABLED = no
ctx_docker_rust__STAGE = images

docker_rust__IN = $(MK)/docker.mk
docker_rust__OUT_DIR = $(d__OUTDIR)/docker
docker_rust__OUT = $(docker_rust__OUT_DIR)/rust.mk

docker_rust__CONTAINER = builder_rust
docker_rust__CTX = $(d__PROJECT_ROOT)
docker_rust__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust
docker_rust__TAG = latest
docker_rust__IMAGE = $(call docker_image,rust,$(docker_rust__TAG))

# docker build_args
docker_rust__arg_BASE_IMAGE = $(d__DOCKER_ALPINE_IMAGE)
docker_rust__arg_RUST_VERSION = $(d__DOCKER_RUST_VERSION)
docker_rust__arg_TARGET_ARCH = $(d__DOCKER_RUST_TARGET_ARCH)
docker_rust__arg_SQLX_VERSION = 0.7.1

# docker_rust__BUILD_ARGS = $(call list_by_prefix,docker_rust__arg_)

CTXES += docker_rust

########################################################################################################################
# docker_bar
########################################################################################################################
ctx_docker_bar__ENABLED = no
ctx_docker_bar__STAGE = images docker-apps

docker_bar__IN = $(MK)/docker.mk
docker_bar__OUT_DIR = $(d__OUTDIR)/docker
docker_bar__OUT = $(docker_bar__OUT_DIR)/bar.mk

docker_bar__CONTAINER = bar
docker_bar__CTX = $(d__PROJECT_ROOT)
docker_bar__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_bar__PUBLISH = 8081:80/tcp
docker_bar__IMAGE = $(call docker_image,bar,$(docker_bar__TAG))

# docker build_args
docker_bar__arg_APP = bar
docker_bar__arg_BUILDER = $(docker_rust__IMAGE)
docker_bar__arg_BUILD_PROFILE = $(d__CARGO_PROFILE)
docker_bar__arg_BUILD_VERSION = $(d__BUILD_VERSION)
docker_bar__arg_TARGET_ARCH = $(d__DOCKER_RUST_TARGET_ARCH)
docker_bar__arg_BASE_IMAGE = $(d__DOCKER_ALPINE_IMAGE)

# docker envs
$(call inherit_ctx,bar__env_,docker_bar__env_)

CTXES += docker_bar

########################################################################################################################
# docker_foo
########################################################################################################################
ctx_docker_foo__ENABLED = no
ctx_docker_foo__STAGE = images docker-apps

docker_foo__IN = $(MK)/docker.mk
docker_foo__OUT_DIR = $(d__OUTDIR)/docker
docker_foo__OUT = $(docker_foo__OUT_DIR)/foo.mk

docker_foo__CONTAINER = foo
docker_foo__CTX = $(d__PROJECT_ROOT)
docker_foo__DOCKERFILE = $(DOCKERFILES)/Dockerfile.rust_app
docker_foo__PUBLISH = 9081:80/tcp
docker_foo__IMAGE = $(call docker_image,foo,$(docker_foo__TAG))

# docker build_args
$(call copy_ctx,docker_bar__arg_,docker_foo__arg_)
docker_foo__arg_APP = foo
# docker_foo__arg_BUILDER = $(docker_rust__IMAGE)
# docker_foo__arg_BUILD_PROFILE = $(d__CARGO_PROFILE)
# docker_foo__arg_BUILD_VERSION = $(d__BUILD_VERSION)
# docker_foo__arg_TARGET_ARCH = $(d__DOCKER_RUST_TARGET_ARCH)
# docker_foo__arg_BASE_IMAGE = $(d__DOCKER_ALPINE_IMAGE)

# # docker envs
$(call inherit_ctx,foo__env_,docker_foo__env_)

CTXES += docker_foo
