## Writing a package build script
by creating a package build script, it's package build script information should be in `$HOME/.shpkg/package` containing the file `SHPKG_BUILD`

`SHPKG_BUILD` file example:
```bash
# package name
shpkg_name="Hello World"

# package build dependencies
shpkg_build_depends="make automake gcc clang"

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

The `SHPKG_BUILD` script has four functions:
* `prepare()` - for preparation of build script installation (usually sha256sum checking, applying patch files, running `configure` script, etc)

* `build()` - for building packages with this function

* `finish()` - for installing packages

* `remove()` - for running uninstall commands if a user invoked `shpkg uninstall <package>`

Those functions are used to install packages, all of these functions are optional, `build()` function as an example can be removed if a package is platform-independent


## shpkg build script fields
| Variable                       | Value(s)                                | Required?         | Description                                                                                                                                  |
|--------------------------------|-----------------------------------------|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| `shpkg_name`                   | Any                                     | Yes (recommended) | Package name |
| `shpkg_source`                 | `https://foo.bar/example-source.tar.gz` | Yes               | Package source code URL (tar, zip, git url) |
| `shpkg_description`            | Any                                     | No                | Package Description |
| `shpkg_version`                | Any                                     | No                | Package version |
| `shpkg_depends`                | dependency1 dependency2                 | No                | Package runtime dependency |
| `shpkg_build_depends`          | dependency1 dependency2                 | No                | Package build dependency (for compilation) |
| `shpkg_source_archive_zip`     | true/false                              | No                | Tell if to use `unzip` as an extractor (if the tarball is zip) |
| `shpkg_no_strip_tarball`       | true/false                              | No                | Tell if not to tell extractor to use `--strip` argument by default (use this if you want to retain subdirectories) |
| `shpkg_enable_verbose_logging` | true/false                              | No                | Tell if to enable verbose extraction |
| `shpkg_distro_only`            | debian/archlinux/redhat/alpine/termux   | No                | Tell if to install package for specific distro only (Alternatively, a user can specify case statements with `SHPKG_DISTRO` variable)         |
| `shpkg_arch_only`              | amd64/i386/arm64/armhf                  | No                | Tell if to install package for specific architecture only (Alternatively, a user can use case statement whether to detect arch with `uname`) |
| `shpkg_src_use_git`            | true/false                              | Yes (if the source code url is git url) | Tell whether to use `git` to fetch the source code and include submodules by default (this option is available since `shpkg` v1.2.0) |
| `shpkg_git_depth`              | 1...9                                   | No                | Pass the option `--depth=` to `git`, this method saves disk space when cloning large repositories
| `shpkg_git_branch`             | repository branch                       | No                | By default, it will clone the repository using `master` branch, use this option to use other branches
| `shpkg_git_skip_include_submodule` | true/false                          | No                | Tell not to include submodules when git cloning a repository

## Build script suggestions
* For dropping privileges and executing commands as `root`, instead of using `sudo` command, interpret `${SHPKG_SUDO}` variable instead: \
`${SHPKG_SUDO} apt update`

* Specify a dedicated prefix directory for easy package removal, depending on your source's build system type it could be `--prefix=/path/to/dir` or `-DCMAKE_INSTALL_PREFIX:PATH=/path/to/dir`

* Specify `remove()` function for package removal

* Avoid unbound variables, you may need to use `${UNBOUND_VAR:-}` colon-dash and bracket it to fallback to something on your buildscript