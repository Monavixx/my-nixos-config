{ inputs, host, ... }:
{
  imports = [ inputs.walker.homeManagerModules.default ];

  programs.walker = {
    enable = true;
    runAsService = true;
    themes.${host.theme.name} = {
      style = builtins.readFile "${inputs.walker-catppuccin}/themes/catppuccin-${host.theme.flavor}/style.css";
    };
    config = {
      theme = host.theme.name;
      hide_quick_activation = true;
      actions_as_menu = true;
      ext_background_effect_blur = true;

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
