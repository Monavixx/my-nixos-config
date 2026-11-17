{
  flake.modules.homeManager.fastfetch = {
    programs.fastfetch = {
      enable = true;

      settings = {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

        logo = {
          source = "nixos";
          padding = {
            right = 4;
          };
        };

        display = {
          separator = "  ›  ";

          color = {
            keys = "cyan";
            title = "bold_cyan";
            output = "white";
            separator = "light_black";
          };

          key = {
            width = 18;
          };

          percent = {
            type = 3;
          };

          bar = {
            width = 10;
            char = {
              elapsed = "━";
              total = "─";
            };
          };
        };

        modules = [
          {
            type = "title";
            color = {
              user = "bold_cyan";
              at = "light_black";
              host = "bold_white";
            };
          }

          {
            type = "separator";
            string = "─";
            outputColor = "light_black";
          }

          "os"
          "host"
          "kernel"
          "uptime"
          "shell"
          "terminal"
          "display"

          "break"

          {
            type = "cpu";
            temp = true;
          }
          {
            type = "gpu";
            temp = true;
          }
          "memory"
          "disk"
          "battery"

          "break"
          "colors"
        ];
      };
    };
  };
}
