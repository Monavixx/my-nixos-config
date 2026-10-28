{ inputs, host, ... }:
{
  imports = [ inputs.walker.homeManagerModules.default ];

  nix.settings = {
    extra-substituters = [
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };

  programs.walker = {
    enable = true;
    runAsService = true;
    themes.${host.theme.name} = {
      style =
        (builtins.readFile "${inputs.walker-catppuccin}/themes/catppuccin-${host.theme.flavor}/style.css")
        + ''
          .window {
            opacity: 0.7;
          }
        '';
    };
    config = {
      theme = host.theme.name;
      hide_quick_activation = true;
      actions_as_menu = true;
      # ext_background_effect_blur = true;
      selection_wrap = true;

      keybinds = {
        show_actions = [ "ctrl b" ];
        next = [
          "Down"
          "ctrl n"
        ];
        previous = [
          "Up"
          "ctrl p"
        ];
        down = [
          "Down"
          "ctrl n"
        ];
        up = [
          "Up"
          "ctrl p"
        ];
      };
      columns = {
        symbols = 5;
      };

      providers = {
        default = [
          "desktopapplications"
          "calc"
        ];
        empty = [ "desktopapplications" ];
        max_results = 200;
        argument_delimiter = {
          runner = " ";
        };

        prefixes = [
          {
            provider = "websearch";
            prefix = "?";
          }
          {
            provider = "providerlist";
            prefix = ";";
          }
          {
            provider = "files";
            prefix = "/";
          }
          {
            prefix = ".";
            provider = "symbols";
          }
          {
            prefix = "!";
            provider = "runner";
          }
          {
            prefix = "-";
            provider = "todo";
          }
          {
            prefix = "%";
            provider = "bookmarks";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = ":";
            provider = "clipboard";
          }
          {
            prefix = "`";
            provider = "windows";
          }
          {
            prefix = "b ";
            provider = "bluetooth";
          }
        ];
      };
    };
  };
}
