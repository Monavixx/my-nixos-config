{ lib, config, ... }:
let
  top = config; # flake-parts config; the inner modules shadow `config`
  rqbitUsers = lib.filterAttrs (_: u: u.rqbit.instances != { }) top.users;
in
{
  # extends the `users` schema declared in modules/flake/users.nix
  options.users = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.rqbit.instances = lib.mkOption {
          default = { };
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                httpPort = lib.mkOption { type = lib.types.port; };
                listenPort = lib.mkOption { type = lib.types.port; };
                downloadDir = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
                stateDir = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                };
              };
            }
          );
        };
      }
    );
  };
  config = {
    flake.modules.homeManager = lib.mapAttrs' (
      _user: u:
      lib.nameValuePair "user-${_user}" (
        { config, pkgs, ... }: {
          systemd.user.services = lib.mapAttrs' (
            name: i:
            let
              downloadDir =
                if i.downloadDir != null then i.downloadDir else "${config.xdg.userDirs.download}/${name}";
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
          ) u.rqbit.instances;
        }
      )
    ) rqbitUsers;

    # NixOS side: open the listen ports on hosts that import this user
    flake.modules.nixos = lib.mapAttrs' (
      user: u:
      lib.nameValuePair "user-${user}" {
        networking.firewall.allowedTCPPorts = lib.mapAttrsToList (_: i: i.listenPort) u.rqbit.instances;
        networking.firewall.allowedUDPPorts = lib.mapAttrsToList (_: i: i.listenPort) u.rqbit.instances;
      }
    ) rqbitUsers;
  };
}
