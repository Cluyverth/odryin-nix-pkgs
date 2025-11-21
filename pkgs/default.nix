{ pkgs, lib }:

lib.mapAttrs (name: value: pkgs.callPackage value {}) (builtins.fromJSON (builtins.readFile ./pkgs.json))