#!/usr/bin/env bash
set -e
GIT_BRANCH="master"
GIT_URL="https://raw.githubusercontent.com/shpkg/shpkg/${GIT_BRANCH}"

# check for operating system (android)
if [ -e /system/bin/app_process ]; then
	INSTALL_DIR="/data/data/com.termux/files/usr/bin"
	DISTRO="android"
	SUDO=""
else
	INSTALL_DIR="/usr/local/bin"
	DISTRO="linux"
	if [ "$(id -u)" == "0" ]; then
		SUDO=""
	else
		SUDO="sudo -Es"
	fi
fi

DEBIAN_INSTALL_DEPS="git curl unzip xz-utils"
NON_DEBIAN_INSTALL_DEPS="git curl unzip xz"

# install deps
${SUDO} bash -c \
	"apt install ${DEBIAN_INSTALL_DEPS} || pacman -S ${NON_DEBIAN_INSTALL_DEPS} --needed \
	|| dnf install ${NON_DEBIAN_INSTALL_DEPS} || apk add ${NON_DEBIAN_INSTALL_DEPS}" 2> /dev/null

# setup repository lists (if possible)
if [ ! -e "${HOME}/.config/shpkg_repo.list" ]; then
	mkdir -p "${HOME}/.config"
	# initialize EOM heredoc by filling repo
	if [ "${DISTRO}" == "android" ]; then
		cat <<-EOM >> "${HOME}/.config/shpkg_repo.list"
		# repository list for shpkg
		# supported types are direct tarball download (zip or tar) or git url
		# e.g.:
		# https://github.com/shpkg/ports.git
		# strip:https://github.com/shpkg/ports/archive/refs/heads/master.zip
		#
		# specify strip: if the tarball containing buildscript uses subdirectories
		https://github.com/shpkg/termux-ports.git
		EOM
	else
		cat <<-EOM >> "${HOME}/.config/shpkg_repo.list"
		# repository list for shpkg
		# supported types are direct tarball download (zip or tar) or git url
		# e.g.:
		# https://github.com/shpkg/ports.git
		# strip:https://github.com/shpkg/ports/archive/refs/heads/master.zip
		#
		# specify strip: if the tarball containing buildscript uses subdirectories
		https://github.com/shpkg/ports.git
		EOM
	fi
fi

# install script
${SUDO} curl --location "${GIT_URL}/shpkg" --output "${INSTALL_DIR}/shpkg"
${SUDO} chmod 755 "${INSTALL_DIR}/shpkg"
