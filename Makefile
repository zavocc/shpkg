# check if $PREFIX is specified
ifeq ($(PREFIX),)
SYSROOT := $(PREFIX)
else
SYSROOT := /usr
endif

install:
	bash install.sh

uninstall:
	rm -rf $(SYSROOT)/bin/shpkg
	rm -rf $(HOME)/.shpkg-lock
	rm -rf $(HOME)/.shpkg

.PHONY: install uninstall