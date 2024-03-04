{ inputs, ... }:

{
  imports = [
    inputs.self.darwinModules.example
  ];

  networking.hostName = "host1";
}
