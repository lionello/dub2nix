with (import <nixpkgs> {});

mkShell {
  buildInputs = [
    dmd dub rdmd nix-prefetch-git
  ];
}

