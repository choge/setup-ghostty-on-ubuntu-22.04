{ config, pkgs, nixgl, ... }:

{
  nixGL.packages = import nixgl {
    inherit pkgs;
  };
  nixGL.defaultWrapper = "mesa";  # or whatever wrapper you need
    nixGL.installScripts = [ "mesa" ];

  home.username = "choge";
  home.homeDirectory = "/home/choge";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap ghostty)
  ];

  programs.home-manager.enable = true;
}

