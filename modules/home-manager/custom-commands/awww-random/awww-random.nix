{ pkgs }:
pkgs.writeShellScriptBin "awww-random" (builtins.readFile ./awww-random.sh)
