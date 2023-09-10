with import <nixpkgs> {};

let
  pkg = import ./default.nix { inherit pkgs; };

in mkShell {

  buildInputs = [
    # additional runtime dependencies go here
  ] ++ pkg.buildInputs ++ pkg.propagatedBuildInputs;

  nativeBuildInputs = [
    # additional dev dependencies go here
    coreutils # fix for mktemp: illegal option -- -
  ] ++ pkg.nativeBuildInputs;

}
