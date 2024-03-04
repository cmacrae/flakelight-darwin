rec {
  default = basic;
  basic = { path = ./basic; description = "Minimal flakelight-darwin flake."; };
  autoload = {
    path = ./autoload;
    description = ''
      Multi-host flakelight-darwin flake using directories.
    '';
  };
}
