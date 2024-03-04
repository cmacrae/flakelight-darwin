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
