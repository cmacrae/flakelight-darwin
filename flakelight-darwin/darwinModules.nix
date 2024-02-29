# flakelight -- A Darwin module for flakelight
# Copyright (C) 2024 Calum MacRae <hi@cmacr.ae>
# SPDX-License-Identifier: MIT

{ config, lib, flakelight, moduleArgs, ... }:
let
  inherit (lib) mkOption mkIf mkMerge;
  inherit (lib.types) lazyAttrsOf;
  inherit (flakelight.types) module nullable optCallWith;
in
{
  options = {
    darwinModule = mkOption {
      type = nullable module;
      default = null;
    };

    darwinModules = mkOption {
      type = optCallWith moduleArgs (lazyAttrsOf module);
      default = { };
    };
  };

  config = mkMerge [
    (mkIf (config.darwinModule != null) {
      darwinModules.default = config.darwinModule;
    })

    (mkIf (config.darwinModules != { }) {
      outputs = { inherit (config) darwinModules; };
    })
  ];
}
