# dub2nix
CLI tool to create Nix expressions for D-lang Dub projects.

## Installation
With Nix:
```sh
nix-env -if https://github.com/lionello/dub2nix/archive/master.zip
```
Or `git clone` and use `direnv` or `nix-shell` to build with `dub`:
```sh
nix-shell
dub
```

## Usage
First, use `dub build` to generate the `dub.selections.json` for your Dub project. 
Then simply run `dub2nix save` to read the `dub.selections.json` in the current folder and write a new file `dub.selections.nix`.
This file can be used with `mkDubDerivation` (from `mkDub.nix`) to create a new derivation for your Dub project:
```nix
{pkgs}:
with (import ./mkDub.nix {
    inherit pkgs;
});
mkDubDerivation {
    version = "0.1.0";
    src = ./.;
}
```
