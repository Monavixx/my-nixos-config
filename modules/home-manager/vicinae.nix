{ inputs, config, ... }:
{
  programs.vicinae =
    let
      vicinae-extensions = inputs.vicinae-extensions + "/extensions";
    in
    {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
      };
      settings = {
        tray = {
          enabled = false;
        };
        close_on_focus_loss = true;
        pop_to_root_on_close = true;
        launcher_window = {
          opacity = 0.7;
        };
        input_server = {
          enabled = false;
        };
        theme = {
          dark = {
            icon_theme = "Papirus-Dark";
          };
        };
        fallbacks = [ ];
        providers = {
          files = {
            enabled = false;
            preferences = {
              autoIndexing = false;
            };
          };
          applications = {
            preferences = {
              launchPrefix = "uwsm app -- ";
            };
          };
        };
      };
      extensions = [
        (config.lib.vicinae.mkExtension {
          name = "nix";
          src = vicinae-extensions + "/nix";
        })
      ];
    };
}
