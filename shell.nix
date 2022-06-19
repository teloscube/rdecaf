{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  devDependencies = [
    rPackages.devtools
  ];

  libDependencies = [
    rPackages.crul
    rPackages.httr
    rPackages.jsonlite
    rPackages.plyr
    rPackages.R6
    rPackages.readr
  ];

  thisR = rWrapper.override {
    packages = devDependencies ++ libDependencies;
  };
in
mkShell {
  buildInputs = [
    thisR
  ];
}
