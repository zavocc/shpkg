## About
Since `shpkg` 1.3.0. an experimental `update` function is implemented, this made it easy to add repos \
requirement is `git`, `zip`, `tar`

## Configs
The config file is in `~/.config/shpkg_repo.list` or `$XDG_CONFIG_HOME/shpkg_repo.list`

An example of repolist file
```
# this is a comment
https://github.com/shpkg/ports.git
https://foo.bar/buildscripts.zip
https://foo.bar/buildscripts.tar.xz
```

when adding repos, `*.git, *.zip, *.tar` extension should be specified at the end to know what method is going to be used when fetching

#### Known bugs in the repolist file
* Newlines are being treated as URL, an implementation fix is welcome (fixed in 1.3.1)
* Comments are also being treated as URL, an implementation fix is welcome (fixed in 1.3.1)

### Buildscript fetching
When fetching buildscripts through git or tarball, buildscripts is being placed in `~/.shpkg/`

If `*.zip, *.tar` is being used, the contents are being extracted in `~/.shpkg/` \
However if the archive contains a subdirectory and the subdirectories contains all buildscripts. specify `strip:` uri option in the repolist

An example:
```
https://github.com/shpkg/ports.git
strip:https://foo.bar/buildscripts-inside-subdirectories.zip
strip:https://foo.bar/buildscripts-inside-subdirectories.tar.xz
```
when `strip:` is specified, it will be extracted in temporary directory then moves the buildscripts in `~/.shpkg/`

if `strip:` isn't specified, it will treat it as build script

Note that if `strip:` was specified in `git` url. it is being ignored, please see [Repository Structure](#Repository-Structure) if creating your own `shpkg` repo

## Repository Structure
If creating a `shpkg` repo, the following directotu structure should be followed. in a nutshell:

#### git
```
shpkg-alternate-repo-root \
  -- package1 \
          -- SHPKG_BUILD
  -- package2 \
          -- SHPKG_BUILD
```

`shpkg-alternate-repo-root` - the git repo name, represents as repository root. would be: \
`https://github.com/foo/shpkg-alternate-repo-root`

#### tar
If `strip:` should not be specified:
```
buildscripts.tar.* \
  -- package1 \
          -- SHPKG_BUILD
  -- package2 \
          -- SHPKG_BUILD
```

If `strip:` should be specified:
```
buildscripts-inside-subdirectories.tar.* \
  -- subdirectory \
    -- package1 \
            -- SHPKG_BUILD
    -- package2 \
            -- SHPKG_BUILD
```

#### zip
If `strip:` should not be specified:
```
buildscripts.zip \
  -- package1 \
          -- SHPKG_BUILD
  -- package2 \
          -- SHPKG_BUILD
```

If `strip:` should be specified:
```
buildscripts-inside-subdirectories.zip \
  -- subdirectory \
    -- package1 \
            -- SHPKG_BUILD
    -- package2 \
            -- SHPKG_BUILD
```