{pkgs}:
with (import ./mkDub.nix {
    inherit pkgs;
});
mkDubDerivation {
    src = ./.;
    # dubJSON = ./dub.json;
    # selections = ./dub.selections.nix;
    version = "0.2.3";
    propagatedBuildInputs = [ pkgs.nix-prefetch-git ];
    meta = with pkgs.stdenv.lib; {
       homepage = "https://github.com/lionello/dub2nix";
       maintainers = [ maintainers.lionello ];
       license = licenses.mit;
    };
}
