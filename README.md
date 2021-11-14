# shpkg (shell-scripted package manager)
A Package manager written in `bash` with a `makepkg`-like format similar

# Why?
* Because I can
* Because I have free time in my hands
* Because I am bored
* Why not?

Above those are the reasons why i made this script 😏

# Table of Contents
- [shpkg (shell-scripted package manager)](#shpkg-shell-scripted-package-manager)
- [Why?](#why)
- [Table of Contents](#table-of-contents)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Features](#features)
- [Build scripts](#build-scripts)
- [Repositories](#repositories)
- [Contributing](#contributing)

# Dependencies
* **Bash** - obviously. suggested is the 4.0+ bash version
* **Git** - for the use of updating repository information and fetching buildscripts
* **`sudo`** - for privilege dropping (we don't need to run this script as root, we call it)
* **`unzip`** - for dealing with `.zip` archives
* **`tar`** - needed. including `gzip` and `xzip` archivers

# Installation
It usually takes less than a minute to install. you may download [shpkg](./shpkg) script
```sh
curl -fsSL https://raw.githubusercontent.com/WMCB-Tech/shpkg/master/shpkg | tee shpkg
```

# Features
Features include:
* Support for tracking dependency needs for a package (this feature is only available in Debian, Arch, Alpine Linux and Fedora)
* Simple and only includes core functionality
* Compilation of programs easily for your convinence
* It's quite similar to portage, homebrew or makepkg
* Portable and supports most operating systems (windows/macOS may have small support)

# Build scripts
Build scripts are stored in your home directory which is `~/.shpkg`. containing all build script directories 
```
~ $ ls -R ~/.shpkg
bash:
SHPKG_BUILD

hello-world:
SHPKG_BUILD hello_world.c
```

Sample build script
```sh
# package name
shpkg_name="Hello World"

# package build dependencies
shpkg_build_depends="make automake gcc clang"

# package architecture
shpkg_arch_only=('amd64' 'i386')

# package version
shpkg_version="2.9"

# package source code
shpkg_source="https://mirror.ossplanet.net/gnu/hello/hello-${shpkg_version}.tar.gz"

prepare(){
	cd "${SRCDIR}"
	./configure --prefix=/opt/shpkg/gnu-hello
}

build(){
	make -j$(nproc)
}

finish(){
	${SHPKG_SUDO} make install
}

remove(){
	${SHPKG_SUDO} rm -rf /opt/shpkg/gnu-hello
}
```

See the [docs](./docs/packages.md) for more information
# Repositories
You can also setup repository where build scripts are being downloaded. the repository list location is located at `~/.config/shpkg-repo.list`

Example config file:
```
# this is a comment
https://github.com/foo/bar.git
https://example.com/foo/bar.tar.gz
https://example.com/foo/bar.zip
```

Your repository root directory (`/`) should have build scripts directory which shown above. it will download and move all files to `~/shpkg` directory which contains all buildscripts

Steps include:
- It fetches URL's based on their file extension (git or tar archive)
- Extracts contents to temporary directory
- Moves all directories from temporary directory to `~/.shpkg` directory

# Contributing
You may contribute. issues and pull requests are welcome! you are also free to fork this repo! \
If you have any further questions. you may ask in discussions tab
