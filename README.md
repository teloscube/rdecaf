# rdecaf: DECAF API Client for R Language

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

## LICENSE

This work is released under MIT license.

See [./LICENSE](./LICENSE).
