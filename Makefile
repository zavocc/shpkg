install:
	bash install.sh

uninstall:
	if [ -n "${PREFIX}" ]; then \
		rm -rf ${PREFIX}/bin/shpkg; \
	else \
		rm -rf /usr/local/bin/shpkg; \
	fi

	rm -rf $(HOME)/.shpkg-lock
	rm -rf $(HOME)/.shpkg

.PHONY: install uninstall