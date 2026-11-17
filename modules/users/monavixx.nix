let
  username = "monavixx";
in
{
  users.${username} = rec {
    email = "dperelygin0@gmail.com";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    fullName = "Monavixx";

    home = "/home/${username}";
    xdg = {
      download = "${home}/download";
    };

    rqbit.instances = {
      rqbit = {
        httpPort = 3030;
        listenPort = 4240;
        downloadDir = xdg.download;
      };
    };
  };

  flake.modules.nixos."user-${username}" = { pkgs, ... }: {
    users.users.${username} = {
      shell = pkgs.zsh;
    };
  };
}
