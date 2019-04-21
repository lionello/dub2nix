{pkgs, dmd, dub, rdmd, stdenv}:
with (import ./mkDub.nix {
    inherit pkgs dmd dub rdmd stdenv;
});
mkDubDerivation {
}
