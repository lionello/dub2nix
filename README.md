# dub2nix
CLI tool to create Nix expressions for D-lang Dub projects.

![CI](https://github.com/lionello/dub2nix/workflows/CI/badge.svg)

## Installation
Install with `nix-env`:
```sh
nix-env -if https://github.com/lionello/dub2nix/archive/master.tar.gz
```
or add to your `shell.nix` and run `nix-shell`:
```nix
with import <nixpkgs> {};
let
  dub2nix-src = fetchTarball {
    url = "https://github.com/lionello/dub2nix/archive/master.tar.gz";
  };
  dub2nix = (import dub2nix-src) { inherit pkgs; };
in mkShell {
  buildInputs = [
    dub2nix # dub dmd dtools ldc etc..
  ];
}
```

## Development
Do `git clone` and `nix-shell` to build with `dub`:
```sh
nix-shell
dub
```
Alternatively, use `direnv`:
```sh
echo use nix >> .envrc
direnv allow
dub
```

## Usage
```
Usage: dub2nix [OPTIONS] COMMAND

Create Nix derivations for Dub package dependencies.

Commands:
  save         Write Nix files for Dub project

Options:
-i     --input Path of selections JSON; defaults to ./dub.selections.json
-o    --output Output Nix file for Dub project
-r  --registry URL to Dub package registry; default http://code.dlang.org/packages/
-d --deps-file Output Nix file with dependencies; defaults to ./dub.selections.nix
-h      --help This help information.
```
First, use `dub build` to generate the `dub.selections.json` for your Dub project.
Then, run `dub2nix save` to read the `dub.selections.json` in the current folder and write a new file `dub.selections.nix`.

This `dub.selections.nix` is used in `mkDubDerivation` (from `mkDub.nix`) to create a new derivation for your Dub project:
```nix
{pkgs}:
with (import ./mkDub.nix {
    inherit pkgs;
});
mkDubDerivation {
    version = "0.1.0"; # optional
    src = ./.;
}
```

When your project has no dependencies at all, this will fail because `dub.selections.nix` is missing. Set `deps` to override the dependencies:
```nix
{pkgs}:
with (import ./mkDub.nix {
    inherit pkgs;
});
mkDubDerivation {
    src = ./.;
    deps = [];
}
```

Use the `--output` option to write a `.nix` file with a skeleton derivation for your dub project. This will also create the `mkDub.nix` file for importing into the derivation.
