{ config, ... }:
{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
      music = "${config.home.homeDirectory}/music";
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/documents";
      setSessionVariables = true;
      desktop = null;
      projects = null;
      publicShare = null;
      templates = null;
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/json" = "nvim.desktop";
        "application/schema+json" = "nvim.desktop";
      };
    };
    configFile."mimeapps.list".force = true;
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "kitty.desktop" ];
      };
    };
  };
}
