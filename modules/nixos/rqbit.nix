{ config, username, ... }:
{
  services.rqbit = {
    enable = true;
    downloadDir = "${config.users.users.${username}.home}/Downloads";
    httpPort = 3030;
    user = username;
    group = "users";
  };
}
