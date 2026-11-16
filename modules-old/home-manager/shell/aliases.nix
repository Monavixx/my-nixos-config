{ lib, ... }:
{
  home.shellAliases = {
    ".." = "cd ..";
    rm = lib.mkDefault "rm -i";
  };
}
