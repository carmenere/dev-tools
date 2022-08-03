#!/usr/bin/env sh

# ATTENTION!
#   1) The file 'configure.sh' is designed to adapt the script './configure' to the developer's local environment.
#   2) Please follow the steps below before using:
#      a) Copy this file to your project root.
#      b) Add this file to '.gitignore' of your project.
#      c) Set appropriate parameters for './configure' script.
#      d) Run 'source configure.sh'.
# 
# Also you can run following command: 'git update-index --skip-worktree configure.sh' instead excluding this file from git repo.
#      The –skip-worktree option ignores uncommitted changes in a file that is already tracked and git will always use the file content from the staging area. 
#      This is useful when we want to add local changes to a file without pushing them to the upstream.

make distclean

# Example 1
#     autoreconf -fi . && \
#     ./configure \
#         BUILD_VERSION="$(git describe --tags)" \
#         POSTGRES_SUPERUSER="an.romanov" \
#         POSTGRES_AUTH_METHOD="peer" \
#         TARGET_ARCH="aarch64-apple-darwin" \
#         BUILD_MODE="debug"


# Example 2
#     cd service_a  && \
#         autoreconf -fi . && \
#         ./configure \
#             build_version="$(shell git describe --tags)" \
#             POSTGRES_SUPERUSER="postgres" \
#             POSTGRES_AUTH_METHOD="remote" \
#             TARGET_ARCH="aarch64-apple-darwin" \
#             BUILD_MODE="debug"
# 
#     cd service_b  && \
#         autoreconf -fi . && \
#         ./configure \
#             build_version="$(shell git describe --tags)" \
#             POSTGRES_SUPERUSER="postgres" \
#             POSTGRES_AUTH_METHOD="remote" \
#             TARGET_ARCH="aarch64-apple-darwin" \
#             BUILD_MODE="release"
#             LDFLAGS="${LDFLAGS} -L/opt/homebrew/opt/openssl@1.1/lib" \
#             CPPFLAGS="${CPPFLAGS} -I/opt/homebrew/opt/openssl@1.1/include" \
#             PYTHONEXECUTABLE="$(echo $(pyenv shell 3.9.5 && pyenv which python))"