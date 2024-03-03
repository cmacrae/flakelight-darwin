# flakelight-darwin

A [nix-darwin][1] module for [flakelight][2].

[1]: https://github.com/LnL7/nix-darwin
[2]: https://github.com/nix-community/flakelight

## About
Provides integration for `darwinConfigurations` & `darwinModules` into your flakelight config, like so:
```nix
{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    flakelight-darwin.url = "github:cmacrae/flakelight-darwin";
  };
  outputs = { flakelight, flakelight-darwin, ... }: flakelight ./. {
    imports = [ flakelight-darwin.flakelightModules.default ];
    darwinConfigurations.example = {
      system = "aarch64-darwin";
      modules = [{ system.stateVersion = 4; }];
    };
  };
}
```

This mimics the expression of `nixosConfigurations` & `nixosModules` found in flakelight. Thus it benefits
from the same [directory][3] and [module(s)][4] conventions, such that:
- you can track your `darwinConfigurations` & `darwinModules` in directories, named `darwin` & `darwinModules`
- singular modules expressed directly (`darwinModule = { ... }`) yield the `default` attribute
- module declarations can point to paths

[3]: https://github.com/nix-community/flakelight/blob/master/API_GUIDE.md#nixdir
[4]: https://github.com/nix-community/flakelight/blob/master/API_GUIDE.md#nixosmodules-homemodules-and-flakelightmodules

For further guidance, consult [flakelight's excellent API guide][5] and note the documentation on `nixosConfigurations` 
& `nixosModules`, wherein you can substitute `darwinConfigurations` & `darwinModules`

[5]: https://github.com/nix-community/flakelight/blob/master/API_GUIDE.md
