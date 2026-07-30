{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      sumneko.lua
    ];
    profiles.default.userSettings = {
      "editor.fontFamily" = "'FantasqueSansM Nerd Font', 'JetBrains Mono', monospace";
      "editor.fontLigatures" = true;
    };
  };
}
