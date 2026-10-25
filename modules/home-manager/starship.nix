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
    };
  };
}
