{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      paging = "never";
    };
    extraPackages = with pkgs.bat-extras; [
      batman
    ];
  };
  home.shellAliases = {
    cat = "bat";
    man = "batman";
  };
}
