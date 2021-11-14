## Writing a package build script
by creating a package build script, it's package build script information should be in `$HOME/.shpkg/package` containing the file `SHPKG_BUILD`

`SHPKG_BUILD` file example:
```bash
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

The `SHPKG_BUILD` script has four functions:
* `prepare()` - for preparation of build script installation (usually sha256sum checking, applying patch files, running `configure` script, etc)

* `build()` - for building packages with this function

* `finish()` - for installing packages

* `remove()` - for running uninstall commands if a user invoked `shpkg uninstall <package>`

Those functions are used to install packages, all of these functions are optional, `build()` function as an example can be removed if a package is platform-independent


## shpkg build script fields
| Variable                           | Value(s)                                | Required?                               | Description                                                                                                                                  |
| ---------------------------------- | --------------------------------------- | --------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `shpkg_name`                       | Any                                     | Yes (recommended)                       | Package name                                                                                                                                 |
| `shpkg_source`                     | `https://foo.bar/example-source.tar.gz` | No                                      | Package source code URL (tar, zip, git url)                                                                                                  |
| `shpkg_description`                | Any                                     | No                                      | Package Description                                                                                                                          |
| `shpkg_version`                    | Any                                     | No                                      | Package version                                                                                                                              |
| `shpkg_depends`                    | Package Dependency Name                 | No                                      | Package runtime dependency                                                                                                                   |
| `shpkg_build_depends`              | Package Dependency Name                 | No                                      | Package build dependency (for compilation)                                                                                                   |
| `shpkg_source_archive_zip`         | Boolean                                 | No                                      | Tell if to use `unzip` as an extractor (if the tarball is zip)                                                                               |
| `shpkg_no_strip_tarball`           | Boolean                                 | No                                      | Tell if not to tell extractor to use `--strip` argument by default (use this if you want to retain subdirectories)                           |
| `shpkg_enable_verbose_logging`     | Boolean                                 | No                                      | Tell if to enable verbose extraction                                                                                                         |
| `shpkg_disable_auto_patch_src`     | Boolean                                 | No                                      | Tell whether to disable auto patching `.patch` files to the source code                                                                      |
| `shpkg_arch_only`                  | amd64, i386, arm64, armhf               | No                                      | Tell if to install package for specific architecture only (Alternatively, a user can use case statement whether to detect arch with `uname`) |
| `shpkg_src_use_git`                | Boolean                                 | Yes (if the source code url is git url) | Tell whether to use `git` to fetch the source code and include submodules by default (this option is available since `shpkg` v1.2.0)         |
| `shpkg_git_depth`                  | 1...9                                   | No                                      | Pass the option `--depth=` to `git`, this method saves disk space when cloning large repositories                                            |
| `shpkg_git_branch`                 | repository branch                       | No                                      | By default, it will clone the repository using `master` branch, use this option to use other branches                                        |
| `shpkg_git_skip_include_submodule` | Boolean                                 | No                                      | Tell not to include submodules when git cloning a repository                                                                                 |

## Properties within build script
Suppose you don't want to use `shpkg_source` or want to know what's currently going on during initial setup of build scripts. here's the following properties within the buildscript

* the current working directory is in `${SHPKG_PKGDIRS}/package/`
* the source code directory is set as variable `${SRCDIR}` in `${SHPKG_PKGDIRS}/package/` however this is unavailable if `${shpkg_source}` is not specified and you'll manually implement your own
* auto-patching will go to source code directory which is `${SRCDIR}` (again when `${shpkg_source}` is not specified then will not auto-patch it)

## Build script suggestions
* For dropping privileges and executing commands as `root`, instead of using `sudo` command, interpret `${SHPKG_SUDO}` variable instead: \
`${SHPKG_SUDO} apt update`

* Specify a dedicated prefix directory for easy package removal, depending on your source's build system type it could be `--prefix=/path/to/dir` or `-DCMAKE_INSTALL_PREFIX:PATH=/path/to/dir`

* Specify `remove()` function for package removal

* Avoid unbound variables, you may need to use `${UNBOUND_VAR:-}` colon-dash and bracket it to fallback to something on your buildscript

* All commands must be in appropriate functions, (applying patches through `prepare()`), this is done to provide clean code style of the build script