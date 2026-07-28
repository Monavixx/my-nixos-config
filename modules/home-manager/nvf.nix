{ lib, pkgs, config, inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  programs.nvf = {
    enable = true;
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };
      vim = {
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha"; # other options: "latte", "frappe", "macchiato"
        };
        autocomplete.blink-cmp = {
            enable = true;
            friendly-snippets.enable = true; # community snippet collection
        };
        languages = {
          csharp = {
            enable = true;
            lsp.enable = true;
            lsp.servers = [ "roslyn-ls" ];
          };
          nix = {
            enable = true;
            lsp = {
              enable = true;
              servers = [ "nixd" ]; # eval-aware LSP: option completion, real diagnostics
            };

            format = {
              enable = true;
              type = [ "nixfmt" ]; # official RFC 166 formatter
            };

            treesitter.enable = true; # syntax highlighting, indentation, textobjects

            extraDiagnostics = {
              enable = true;
              types = [ "statix" ]; # anti-pattern linter for Nix
            };
          };
        };
      };
    };
  };
}
