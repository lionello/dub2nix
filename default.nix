{ pkgs ? import <nixpkgs> {} }:
pkgs.callPackage ./dub2nix.nix {}
