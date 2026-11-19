{ inputs, ... }:
{
  den.aspects.walker = {
    provides.to-hosts.nixos = {
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
    };
    homeManager = {
      imports = [ inputs.walker.homeManagerModules.default ];

      programs.walker = {
        enable = true;
        runAsService = true;
        themes."catppuccin-mocha-flamingo-standard" = {
          style = (builtins.readFile "${inputs.walker-catppuccin}/themes/catppuccin-mocha/style.css") + ''
            .window {
              opacity: 0.7;
            }
          '';
        };
        config = {
          theme = "catppuccin-mocha-flamingo-standard";
          hide_quick_activation = true;
          actions_as_menu = true;
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
    };
  };
}
