{
  den.aspects.yazi.homeManager =
    { config, ... }:
    let
      download = config.xdg.userDirs.download;
    in
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
              run = "cd ${download}";
              desc = "go to ${download}";
            }
          ];
        };
      };
    };
}
