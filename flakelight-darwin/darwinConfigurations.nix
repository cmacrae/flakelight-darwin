# flakelight -- A Darwin module for flakelight
# Copyright (C) 2024 Calum MacRae <hi@cmacr.ae>
# SPDX-License-Identifier: MIT

{ config, lib, inputs, flakelight, moduleArgs, ... }:
let
  inherit (builtins) mapAttrs;
  inherit (lib) foldl mapAttrsToList mkIf mkOption recursiveUpdate;
  inherit (lib.types) attrs lazyAttrsOf;
  inherit (flakelight) selectAttr;
  inherit (flakelight.types) optCallWith;

  # Avoid checking if toplevel is a derivation as it causes the modules
  # to be evaluated.
  isDeriv = x: x ? config.system.build.toplevel;

  mkDarwin = hostname: cfg: inputs.nix-darwin.lib.darwinSystem (cfg // {
    specialArgs = {
      inherit inputs hostname;
      inputs' = mapAttrs (_: selectAttr cfg.system) inputs;
    } // cfg.specialArgs or { };
    modules = [ config.propagationModule ] ++ cfg.modules or [ ];
  });

  configs = mapAttrs
    (hostname: cfg: if isDeriv cfg then cfg else mkDarwin hostname cfg)
    config.darwinConfigurations;
in
{
  options.darwinConfigurations = mkOption {
    type = optCallWith moduleArgs (lazyAttrsOf (optCallWith moduleArgs attrs));
    default = { };
  };

  config = {
    outputs = mkIf (config.darwinConfigurations != { }) {
      darwinConfigurations = configs;
      checks = foldl recursiveUpdate { } (mapAttrsToList
        (n: v: {
          # Wrapping the drv is needed as computing its name is expensive
          # If not wrapped, it slows down `nix flake show` significantly
          ${v.config.nixpkgs.system}."darwin-${n}" = v.pkgs.runCommand
            "check-darwin-${n}"
            { } "echo ${v.config.system.build.toplevel} > $out";
        })
        configs);
    };
    nixDirAliases.darwinConfigurations = [ "darwin" ];
  };
}
