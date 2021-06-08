# shpkg
Simple package manager written in bash inspired by makepkg

`shpkg` lets you install packages with the use of build scripts

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

# Installation
once you have dependencies installed [download](https://raw.githubusercontent.com/shpkg/shpkg/master/shpkg) the `shpkg` script, you can install it by simply placing it into `/usr/local/bin` or `$PREFIX/bin` (for termux)

# Package Installation
Before installing packages with `shpkg`, make sure you have build scripts placed in:
```
$HOME/.shpkg
```
Inside that directory where `shpkg` gathers package build script information

You can try adding sample build scripts by fetching [shpkg/ports](https://github.com/shpkg/ports) repository
```
git clone https://github.com/shpkg/ports $HOME/.shpkg
```

For package installation, you can do
```
shpkg install <package>
```

*NOTE: running `shpkg` under `sudo` isn't necessary, `shpkg` will use sudo automatically*

before installing packages, you can list the packages you added by doing
```
shpkg list
```

# Package Uninstallation
You can simply uninstall package by doing
```
shpkg uninstall <package>
```

Depending on a package's build script, sometimes there's no `remove()` function and you won't be able to uninstall it properly, so be aware of that

# Querying package Information
You can look at the package's build script before installing so you will have the opportunity to look at them first before installing, you can do
```
shpkg query <package>
```

*It opens `less` as a default viewing of `shpkg` build scripts, if you want to change that behaviour, you can specify `PAGER=<viewer>` environment variable*

# To-Do
* Add `shpkg update` option (similar to `apt update`)

