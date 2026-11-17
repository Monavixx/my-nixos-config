{ self, ... }:
{
  flake.modules.homeManager.cli-tools = {
    imports = with self.modules.homeManager; [
      bat
      btop
      docker
      fzf
      ripgrep
      melodec
      mpv
      taskwarrior
      trashy
    ];
  };
}
