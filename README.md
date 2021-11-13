# shpkg (shell-scripted package manager)
A Package manager written in `bash` with a `makepkg`-like format similar

# Why?
* Because I can
* Because I have free time in my hands
* Because I am bored
* Why not?

Above those are the reasons why i made this script 😏

# Table of Contents
* [Requirements](#requirements)
* [Installation](#installation)
* [Features](#features)
* [Build scripts examples](#build_scripts_examples)
* [Contributing](#contributing)

# Requirements
* **Bash** - obviously. suggested is the 4.0+ bash version
* **Git** - for the use of updating repository information and fetching buildscripts
* **sudo** - for privilege dropping (we don't need to run this script as root, we call it)
* **unzip** - for dealing with `.zip` archives
* **tar** - needed. including `gzip` and `xzip` archivers

# Installation
Clone this repository or download shpkg script here from this repository

# Features
Features include:
* Support for tracking dependency needs for a package (this feature is only available in Debian, Arch, Alpine Linux and Fedora)
* Easy to setup binary from source without configuring each time
* Compilation of programs easily for your convinence
* It's quite similar to portage, homebrew or makepkg
* Portable and supports most operating systems (windows/macOS may have small support)

# Build scripts examples
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

# Contributing
You may contribute. issues and pull requests are welcome! you are also free to fork this repo! \
If you have any further questions. you may ask in discussions tab
