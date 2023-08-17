LOCALE = /etc/locale.gen
LANG = en_US.UTF-8

.PHONY: replace-lang init

replace-lang:
	sed -i 's/^# *\($(LANG)\)/\1/' /etc/locale.gen

init: replace-lang
	locale-gen
	update-locale LANG=$(LANG)
