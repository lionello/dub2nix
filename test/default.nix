with import ../mkDub.nix { dcompiler = null; };
let
  drv = mkDubDerivation {
    src = ./.;
    #dubSDL = ./dub.sdl;
    deps = [];
  };
in
  assert drv.name == "myproject";
  assert drv.meta.description == "A little web service of mine.";
  assert drv.meta.homepage == "http://myproject.example.com";
  true
