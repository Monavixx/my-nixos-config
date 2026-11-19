{
  den.aspects.rqbit = {
    nixos = { user, lib, ... }: {
      # NixOS side: open the listen ports on hosts that import this user
      networking.firewall.allowedTCPPorts = lib.mapAttrsToList (_: i: i.listenPort) user.rqbit.instances;
      networking.firewall.allowedUDPPorts = lib.mapAttrsToList (_: i: i.listenPort) user.rqbit.instances;
    };
    homeManager =
      {
        user,
        config,
        pkgs,
        lib,
        ...
      }:
      {
        systemd.user.services = lib.mapAttrs' (
          name: i:
          let
            downloadDir =
              if i.downloadDir != null then
                "${config.home.homeDirectory}/${i.downloadDir}"
              else
                "${config.xdg.userDirs.download}/${name}";
            stateDir = if i.stateDir != null then i.stateDir else "${config.xdg.stateHome}/rqbit-${name}";
          in
          lib.nameValuePair "rqbit-${name}" {
            Unit.Description = "rqbit torrent server (${name})";
            Service = {
              ExecStartPre = lib.escapeShellArgs [
                "${pkgs.coreutils}/bin/mkdir"
                "-p"
                downloadDir
                stateDir
              ];
              ExecStart = lib.escapeShellArgs [
                (lib.getExe pkgs.rqbit)
                "--http-api-listen-addr"
                "127.0.0.1:${toString i.httpPort}"
                "--listen-port"
                (toString i.listenPort)
                "--persistence-location"
                stateDir
                "server"
                "start"
                downloadDir
              ];
              Restart = "on-failure";
              RestartSec = "5s";
            };
            Install.WantedBy = [ "default.target" ];
          }
        ) user.rqbit.instances;
      };
  };
}
