### Targets
.PHONY: default clean-autotools clean-makefile

default: clean

clean-autotools:
	[ ! -f $(srcdir)/config.log ] || rm -fv $(srcdir)/config.log
	[ ! -f $(srcdir)/aclocal.m4 ] || rm -fv $(srcdir)/aclocal.m4
	[ ! -f $(srcdir)/config.status ] || rm -fv $(srcdir)/config.status
	[ ! -f $(srcdir)/configure~ ] || rm -fv $(srcdir)/configure~
	[ ! -d $(srcdir)/autom4te.cache ] || rm -Rfv $(srcdir)/autom4te.cache
	
clean-makefile:
	[ ! -f $(srcdir)/Makefile ] || rm -fv $(srcdir)/Makefile
	[ ! -f $(srcdir)/Envs ] || rm -fv $(srcdir)/Envs

clean: clean-autotools clean-makefile