{ inputs, config, ... }:
{
  programs.vicinae =
    let
      vicinae-extensions =
        # pkgs.fetchFromGitHub {
        #   owner = "vicinaehq";
        #   repo = "extensions";
        #   rev = "5d1d31a698d5ac0b25b7391fcce3d920cd9c552e";
        #   hash = "sha256-u9QmD1FnLf+64o60L4ldx81m88eeK5/EgNYTEAt9qIo=";
        # }
        inputs.vicinae-extensions + "/extensions";
    in
    {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
      };
      settings = {
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
