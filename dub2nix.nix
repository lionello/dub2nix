{pkgs, dcompiler ? pkgs.ldc}:
with (import ./mkDub.nix {
    inherit pkgs dcompiler;
});
mkDubDerivation {
    src = pkgs.lib.cleanSource ./.;
    # dubJSON = ./dub.json;
    # selections = ./dub.selections.nix;
    version = "0.4.0";
    # doCheck = true;
    buildInputs = [ pkgs.makeWrapper pkgs.cacert pkgs.nix-prefetch-git ];
    postFixup = ''
        wrapProgram $out/bin/dub2nix --prefix PATH : ${pkgs.nix-prefetch-git}/bin
    '';
    meta = with pkgs.lib; {
       homepage = "https://github.com/lionello/dub2nix";
       maintainers = [ maintainers.lionello ];
       license = licenses.mit;
    };
}
