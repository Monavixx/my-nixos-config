{
  pkgs,
  inputs,
  hostname,
  ...
}:
{
  imports = [
    inputs.nvf.homeManagerModules.default
  ];
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        extraPlugins = {
          easy-dotnet = {
            package = pkgs.vimPlugins.easy-dotnet-nvim;
            setup = ''
              require("easy-dotnet").setup({})
            '';
          };
          plenary = {
            package = pkgs.vimPlugins.plenary-nvim; # required dependency
          };
          telescope = {
            package = pkgs.vimPlugins.telescope-nvim; # required dependency, also used for project/test pickers
          };
        };
        options = {
          expandtab = true;
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
        };
        viAlias = false;
        vimAlias = true;
        diagnostics.enable = true;
        lsp = {
          trouble.enable = true;
          enable = true;
          formatOnSave = true;
          servers.nixd.settings = {
            nixpkgs.expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }";
            formatting.command = [ "nixfmt" ];
            options = {
              nixos.expr = ''(builtins.getFlake "~/nixos").nixosConfigurations.${hostname}.options'';
              home-manager.expr = ''(builtins.getFlake "~/nixos").homeConfigurations.monavixx.options'';
            };
          };
        };
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
              types = [
                "statix"
                "deadnix"
              ]; # anti-pattern linter for Nix
            };
          };
        };
      };
    };
  };
}
