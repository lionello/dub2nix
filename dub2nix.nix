{pkgs}:
with (import ./mkDub.nix {
    inherit pkgs;
});
mkDubDerivation {
    src = pkgs.lib.cleanSource ./.;
    # dubJSON = ./dub.json;
    # selections = ./dub.selections.nix;
    version = "0.2.4";
    # doCheck = true;
    propagatedBuildInputs = [ pkgs.nix-prefetch-git pkgs.cacert ];
    meta = with pkgs.lib; {
       homepage = "https://github.com/lionello/dub2nix";
       maintainers = [ maintainers.lionello ];
       license = licenses.mit;
    };
}
