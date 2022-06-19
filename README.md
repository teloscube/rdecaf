# rdecaf: DECAF API Client for R Language

![GitHub release (latest by date)](https://img.shields.io/github/v/release/teloscube/rdecaf)
![GitHub contributors](https://img.shields.io/github/contributors/teloscube/rdecaf)
![GitHub](https://img.shields.io/github/license/teloscube/rdecaf)

*rdecaf* is an R library that provides client functionality to DECAF API suite.

DECAF is a proprietary Financial Portfolio Management, Analytics, Reporting and
Productivity Suite offered as a Software as a Service (SaaS) solution. It
provides an API suite over HTTP exposing its functionality and data it hosts.
*rdecaf* is used internally to enhance DECAF's own functionality, and by
third-parties to integrate into third-party systems.

## Installation

*rdecaf* is currently NOT on CRAN. A typical way to install *rdecaf* is via
[devtools](https://devtools.r-lib.org/). For latest released version:

```sh
devtools::install_github("teloscube/rdecaf", ref = "main", upgrade = "ask")
```

... and for the development version:

```sh
devtools::install_github("teloscube/rdecaf", ref = "develop", upgrade = "ask")
```

## Development

Development is carried on under a [Nix](https://nixos.org/explore.html) Shell.
If you are on Nix, you can enter the Nix Shell provided with:

```sh
nix-shell
```

A few things to note:

1. Make sure that the package is in good shape:

    ```sh
    devtools::check(".")
    ```

2. We are using [Semantic Versioning](https://semver.org/). However, we have NOT
   released a major version YET. Therefore, expect breaking changes between
   releases.
3. We are using [Conventional
   Commits](https://www.conventionalcommits.org/en/v1.0.0/) since the
   development version `0.0.5.9000`. Make sure that your commit messages are
   compliant to these conventions. This will ensure a nice, automated changelog
   ([./NEWS.md](./NEWS.md)) generation.
4. Development is carried under the `develop` branch. Pull Requests (PRs) are
   preferred over direct commits to `develop` branch.
5. `main` branch is for the latest released version. No development shall be
   done against the `main` branch.
6. We do not have strong preference over core formatting YET. We are currently
   using the `lintr` tool for this purposes. This can change or `.lintr`
   configuration may change over time.

## Release

Let's assume that we are about to release `0.1.0` and the next development version will be `0.1.0.9000`.

First, enter the Nix Shell:

```sh
nix-shell
```

Set and export next version and next development version variables. For example:

```sh
export _NEXT_VERSION="0.1.0"
export _NEXT_DEV_VERSION="0.1.0.9000"
```

Ensure that you are on `develop` branch and it is up-to-date:

```sh
git checkout develop
git pull
```

Checkout to `main` branch:

```sh
git checkout main
```

Merge `develop` branch to `main` branch:

```sh
git merge --no-ff develop
```

Edit [DESCRIPTION](./DESCRIPTION) and update the version:

```sh
nano ./DESCRIPTION
```

Open R console, and check the package:

```sh
devtools::check(".")
```

This should pass with no errors, warnings or notes:

```txt
0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

Build the package:

```sh
devtools::build(".")
```

Exit the R console. The build package should be in the parent directory now:

```console
$ ls "../rdecaf_${_NEXT_VERSION}.tar.gz"
../rdecaf_0.1.0.tar.gz
```

Update the changelog (NEWS.md):

```sh
git-chglog --next-tag "${_NEXT_VERSION}" --output NEWS.md
```

Commit changes:

```sh
git commit -am "chore(release): ${_NEXT_VERSION}"
```

... and push:

```sh
git push --follow-tags origin main
```

Now, we can create a new GitHub release:

```sh
gh release create "${_NEXT_VERSION}" --title "v${_NEXT_VERSION}" --generate-notes --draft
```

Upload the package to the release:

```sh
gh release upload "${_NEXT_VERSION}" "../rdecaf_${_NEXT_VERSION}.tar.gz"
```

Close the release:

```sh
gh release edit "${_NEXT_VERSION}" --draft=false
```

Now, change to `develop` branch:

```sh
git checkout develop
```

Rebase onto main:

```sh
git rebase main
```

Update [DESCRIPTION](./DESCRIPTION) to reflect next development version:

```sh
nano DESCRIPTION
```

Commit:

```sh
git commit -am "chore: bump development version to ${_NEXT_DEV_VERSION}"
```

And, push:

```sh
git push
```

## LICENSE

This work is released under MIT license.

See [./LICENSE](./LICENSE).
