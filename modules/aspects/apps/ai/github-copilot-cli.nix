{
  den.aspects.github-copilot-cli.homeManager = { pkgs, ... }: {
    home.packages = [
      pkgs.github-copilot-cli
    ];
  };
}
