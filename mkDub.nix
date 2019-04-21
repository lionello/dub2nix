{ pkgs ? import <nixpkgs> {},
  stdenv ? pkgs.stdenv,
  rdmd ? pkgs.rdmd,
  dmd ? pkgs.dmd,
  dub ? pkgs.dub }:

with stdenv;
let
  # Filter function to remove the .dub package folder from src
  filterDub = name: type: let baseName = baseNameOf (toString name); in ! (
    type == "directory" && baseName == ".dub"
  );

  # Convert a GIT rev string (tag) to a simple semver version
  rev-to-version = builtins.replaceStrings ["v" "refs/tags/v"] ["" ""];

  # Fetch a dependency (source only for now)
  fromDub = dubDep: mkDerivation rec {
    name = "${src.name}-${version}";
    version = rev-to-version dubDep.fetch.rev;
    nativeBuildInputs = [ rdmd dmd dub ];
    src = pkgs.fetchgit { inherit (dubDep.fetch) url rev sha256 fetchSubmodules; };
    # buildPhase = ''
    #   runHook preBuild
    #   export HOME=$PWD
    #   dub
    #   runHook postBuild
    # '';

    # outputs = [ "src" "lib" ];

    # installPhase = ''
    #   runHook preInstall
    #   mkdir -p $out/bin
    #   runHook postInstall
    # '';
  };

  # Adds a local package directory (e.g. a git repository) to Dub
  dub-add-local = dubDep: "dub add-local ${(fromDub dubDep).src.outPath} ${rev-to-version dubDep.fetch.rev}";

in {
  inherit fromDub;

  mkDubDerivation = lib.makeOverridable ({
    src ? lib.cleanSource ./.,
    buildInputs ? [],
    deps ? import ./dub.selections.nix,
    attrs ? {},
    passthru ? {},
    dubJSON ? ./dub.json,
    package ? lib.importJSON dubJSON
  }: stdenv.mkDerivation (attrs // {

    name = package.name;

    nativeBuildInputs = [ rdmd dmd dub ];

    inherit buildInputs;
    # buildInputs = buildInputs ++ deps;

    passthru = passthru // {
      inherit dub dmd rdmd;
    };

    src = lib.cleanSourceWith {
      filter = filterDub;
      inherit src;
    };

    buildPhase = ''
      runHook preBuild

      export HOME=$PWD
      ${lib.concatMapStringsSep "\n" dub-add-local deps}
      dub build -b release --combined --skip-registry=all

      runHook postBuild
    '';

    checkPhase = ''
      runHook preCheck

      export HOME=$PWD
      dub test --combined --skip-registry=all

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp -r ${package.targetPath} $out

      runHook postInstall
    '';

    # meta = {
    #   description = (lib.hasAttr "description" dubJSON) .description;
    # };
  }));
}
