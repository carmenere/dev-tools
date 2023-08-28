AC_DEFUN([SET_ARG_VAR],
[
AC_ARG_VAR([$1], [default=$2])
: "${AS_TR_SH([$1]):=$2}"
AC_SUBST(AS_TR_SH([$1]))
])
