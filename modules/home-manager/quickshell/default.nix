{ ... }:
{
  programs.quickshell = {
    enable = true;

    configs = {
      main = ./config;
    };

    activeConfig = "main";

    systemd = {
      # enable = true;
      target = "graphical-session.target";
    };
  };
}
