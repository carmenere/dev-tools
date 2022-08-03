AC_DEFUN([SET_ARG_VAR],
[
    AC_ARG_VAR([$1], [$2 (default=$3)])
    AM_CONDITIONAL([IS_SET], [test -n "${$1}"])
    AM_COND_IF([IS_SET],
               [AC_SUBST($1)],       dnl When $1 is passed to ./configure, e.g., "./configure BUILD_VERSION=1.0"
               [AC_SUBST($1, $3)])   dnl When $1 is not passed to ./configure, default ($3) will be used instead
])