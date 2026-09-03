# shpkg (shell-scripted package manager)
A Package manager written in `bash` with a `makepkg`-like format

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
	- [Optional Dependencies](#optional-dependencies)
- [Installation](#installation)
- [Features](#features)
- [Build scripts](#build-scripts)
- [Repositories](#repositories)
- [FAQs](#faqs)
- [Contributing](#contributing)

# Dependencies
* bash 4.0+ - the main dependency
* posix compliant utilities (includes `cat`, `sed`, `less`, `rm`, `awk`, etc.) and `mktemp` which is included in major distributions and macOS as well

## Optional Dependencies
These dependencies are needed if you're performing certain tasks.
* curl for source code or content downloading
* git for source code fetching
* unzip if you need to use zip source code 
* tar (with gzip/xzip compressor) if you need to use tar source code

these are mainly used for `update` function as well to download buildscripts and source code from internet sources

# Installation
It usually takes less than a minute to install. you may download [shpkg](./shpkg) script
```sh
curl -fsSL https://raw.githubusercontent.com/zavocc/shpkg/master/shpkg | tee shpkg
```

# Features
Features include:
* Support for tracking dependency needs for a package (this feature is only available in Debian, Arch, Alpine Linux and Fedora)
* Simple and only includes core functionality
* Compilation of programs easily for your convinence
* It's quite similar to portage, homebrew or makepkg
* Portable and supports most Linux distributions with other UNIX based OSes to follow.

Note that this is still a hobby-stage project, the realistic roadmap for shpkg so far would be:
* Modularization - rather than putting checks for existence of specific package managers and tar/zip/git commands within the single script, it should become a sourcable "dependency handlers" and "source code handlers". For instance, if the source code download requires authentication, a custom source code handler can authentication first before the source code is downloaded. Similarly, if a user has a custom dependency graph handler, it can be implemented as a dependency handler rather than relying on package managers mentioned above.
* File tracking - This is not yet implemented, currently `remove()` function would mean giving developers a benefit of the doubt for the files they place and may not remove all of them or deviates from the actual goal. The goal is generating mandatory files list in `~/.shpkg/<PACKAGE_NAME>/installed.list` during installation, giving users an option to review the files they can additionally remove if `remove()` did not cover every files it installed on system, and requiring developers to specify install dir in likely a special required variable called `shpkg_install_dir` which shpkg captures for files list before installation and after installation.
* Packages from shpkg scripts as a dependency - Yes, this isn't implemented (so much for a package manager!), the goal here would be scanning build scripts first for existing dependencies available in shpkg directory then falls back to system package manager if there's no such dependency. 

	But, in order for this to reliably work to achieve a fully independent package and dependency management, it needs to orchestrate a dependency tree recursively, meaning to check the existence of a dependency of a package then it would also mean requiring to scan dependency of a dependency of a package and so on. 

	This is quite ambitious and scanning would be slow without indexing, and using other programming language to facilitate this task defeats the purpose of being the package manager written in shell script. For now this is achievable but not reaching at the deepest depth where every dependency would be in the build script. Most likely the stop gap is the dependency of the dependency would require system package manager to install those dependencies while the target package can depend on other dependencies from shpkg build scripts within this level only.

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
- It fetches URL's depending on their file extension (git or tar archive)
- Extracts contents to temporary directory
- Moves all directories from temporary directory to `~/.shpkg` directory

Directory structure for your repository must be used as follows:
- 📁 **root directory (/)** 
- 📁 **package** 
  - 📄`SHPKG_BUILD`

# FAQs
> - Is this a POSIX compliant script?

This script is written in bash so almost certainly it's not quite strictly POSIX compliant.

> - Is windows supported?

As natively? No. Windows is very different from UNIX which shpkg relies on the core concepts and utilities developers expect from UNIX-like and UNIX-based OSes such as existence of bash and filesystem layout, you can install mingw/cygwin tools which includes bash and common unix tools

You better off using Winget instead.

# Contributing
You may contribute. issues and pull requests are welcome! you are also free to fork this repo! \
If you have any further questions. you may ask in discussions tab
