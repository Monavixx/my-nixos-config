{ pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = pkgs.lib.concatStrings [
        "$all"
        "$line_break"
        "$directory"
        "$character"
      ];
      git_branch = {
        symbol = " ";
        style = "bold mauve";
        format = "[$symbol$branch]($style) ";
      };
      os = {
        disabled = false;
        symbols = {
          NixOS = " ";
        };
      };
    };
  };
}
