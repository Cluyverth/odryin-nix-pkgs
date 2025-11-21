{ pkgs ? import <nixpkgs> {} }:

let
  lib = pkgs.lib;
  pkgsPath = ./pkgs;

  allPackages = lib.mapAttrs (name: value:

    lib.makeScope pkgs.newScope (self:
      pkgs.callPackage "${pkgsPath}/${value}" {}
    )
  ) (lib.importJSON "${pkgsPath}/default.json");

in
allPackages