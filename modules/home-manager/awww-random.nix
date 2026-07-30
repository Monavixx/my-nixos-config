{ pkgs }:
pkgs.writeShellScriptBin "awww-random" (builtins.readFile ../../scripts/awww-random.sh)
