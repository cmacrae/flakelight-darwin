{ config, pkgs, ... }:

{
  networking.computerName = config.networking.hostName;
  networking.localHostName = config.networking.hostName;

  nix.configureBuildUsers = true;

  programs.bash.enable = false;
  environment.systemPackages = [ pkgs.gcc ];

  security.pam.enableSudoTouchIdAuth = true;
}
