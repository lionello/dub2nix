{pkgs}:
with (import ./mkDub.nix {
    inherit pkgs;
});
mkDubDerivation {
    src = ./.;
    # dubJSON = ./dub.json;
    # selections = ./dub.selections.nix;
    version = "0.1.0";
    meta = with pkgs; {
        maintainers = [ lib.maintainers.lionello ];
    };
}
