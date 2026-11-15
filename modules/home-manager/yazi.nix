{ ... }:
{
  programs.yazi = {
    enable = true;
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ~/downloads";
          desc = "go to ~/downloads";
        }
      ];
    };
  };
}
