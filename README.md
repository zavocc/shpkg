# shpkg
Simple package manager written in bash inspired by makepkg

shpkg lets you install packages with the use of build scripts

# Supported now
currently, the following distributions supported are:
* Debian and it's derivatives
* Arch Linux
* Redhat based distros (with `dnf` package manager like fedora)
* Alpine
* Android (Termux)

# Dependencies for shpkg
Current requirements for shpkg are
* bash 4.0+
* curl
* less
* sudo (not required for termux)

Optional dependencies for shpkg
* unzip (for dealing with zip tarballs)

