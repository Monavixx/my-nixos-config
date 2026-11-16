let
  username = "monavixx";
in
{
  users.${username} = {
    email = "dperelygin0@gmail.com";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
  };

  flake.modules.nixos."user-${username}" = { pkgs, ... }: {
    users.users.${username} = {
      shell = pkgs.zsh;
    };
  };
}
