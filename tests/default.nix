# flakelight -- A Darwin module for flakelight
# Copyright (C) 2024 Calum MacRae <hi@cmacr.ae>
# SPDX-License-Identifier: MIT

{ self, nix-darwin, ... }:
let
  flakelight-darwin = self;
  test = flake: test: assert test flake; true;
  inherit (self.inputs.flakelight.inputs) nixpkgs;
  inherit (nixpkgs) lib;
in
{
  call-flakelight-darwin = test
    (flakelight-darwin ./empty { outputs.test = true; })
    (f: f.test);

  darwinConfigurations = test
    (flakelight-darwin ./empty ({ lib, ... }: {
      darwinConfigurations.test = {
        system = "aarch64-darwin";
        modules = [{ system.stateVersion = 4; }];
      };
    }))
    (f: f ? darwinConfigurations.test.config.system.build.toplevel);

  darwinConfigurationsManual = test
    (flakelight-darwin ./empty ({ lib, ... }: {
      darwinConfigurations.test = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [{ system.stateVersion = 4; }];
      };
    }))
    (f: f ? darwinConfigurations.test.config.system.build.toplevel);

  darwinModule = test
    (flakelight-darwin ./empty {
      darwinModule = _: { };
    })
    (f: f ? darwinModules.default);

  darwinModules = test
    (flakelight-darwin ./empty {
      darwinModules.test = _: { };
    })
    (f: f ? darwinModules.test);
}
