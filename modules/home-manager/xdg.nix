{ ... }:
{
  xdg = {
    userDirs = {

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
