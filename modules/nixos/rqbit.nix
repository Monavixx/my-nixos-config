{ config, username, ... }:
{
  services.rqbit = {
    enable = true;
    downloadDir = config.home-manager.users.${username}.xdg.userDirs.download;
    httpPort = 3030;
    user = username;
    group = "users";
  };
}
