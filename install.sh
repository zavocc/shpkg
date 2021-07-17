#!/usr/bin/env bash
set -e
GIT_BRANCH="master"
GIT_URL="https://raw.githubusercontent.com/shpkg/shpkg/${GIT_BRANCH}"

# check for operating system (android)
if [ -e /system/bin/app_process ]; then
	INSTALL_DIR="/data/data/com.termux/files/usr/bin"
	REPO_LIST="shpkg_repo_android.list"
	SUDO=""
else
	INSTALL_DIR="/usr/local/bin"
	REPO_LIST="shpkg_repo.list"
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

# setup repository lists
mkdir -p "${HOME}/.config"
curl --silent --fail --location "${GIT_URL}/config/${REPO_LIST}" --output "${HOME}/.config/shpkg_repo.list"

# install script
${SUDO} curl --location "${GIT_URL}/shpkg" --output "${INSTALL_DIR}/shpkg"
${SUDO} chmod 755 "${INSTALL_DIR}/shpkg"

