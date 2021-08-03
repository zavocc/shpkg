# check if $PREFIX is specified
ifeq ($(PREFIX),)
SYSROOT := $(PREFIX)
else
SYSROOT := /usr
endif

install:
	bash install.sh

uninstall:
<<<<<<< HEAD
	rm -rf $(SYSROOT)/bin/shpkg
=======
	if [ -n "${PREFIX}" ]; then \
		rm -rf ${PREFIX}/bin/shpkg; \
	else \
		rm -rf /usr/local/bin/shpkg; \
	fi

>>>>>>> make sh if else statement visible
	rm -rf $(HOME)/.shpkg-lock
	rm -rf $(HOME)/.shpkg

.PHONY: install uninstall