{ den, lib, ... }:
{
  den.aspects.quickshell = {
    settings.fingerprint = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable fingerprint authentication in Quickshell's lock screen.";
    };
    includes = with den.aspects; [ wallpapers ];
    nixos = { lib, config, ... }: {
      security.pam.services = {
        quickshell-fprint = lib.mkIf config.services.fprintd.enable {
          fprintAuth = true;
          unixAuth = false; # fingerprint only; the password has its own service
        };
        quickshell-lock = {
          unixAuth = true;
          fprintAuth = false;
        };
      };
    };
    homeManager = { host, pkgs, ... }: {
      home.sessionVariables = {
        QS_CONFIG_NAME = "main";
      };
      programs.quickshell = {
        enable = true;
        configs.main = pkgs.runCommand "quickshell-main-config" { } ''
          mkdir -p "$out"
          cp -r ${./config}/. "$out/"
          chmod u+w "$out/core"
          cat > "$out/core/Host.qml" <<'EOF'
          pragma Singleton
          import Quickshell

          Singleton {
              readonly property bool fingerprintEnabled: ${
                if host.settings.quickshell.fingerprint then "true" else "false"
              }
          }
          EOF
        '';
        activeConfig = "main";
        systemd = {
          enable = true;
          # target = "graphical-session.target";
        };
      };
    };
  };
}
