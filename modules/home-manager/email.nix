{ pkgs, config, ... }:
{
  accounts.email.accounts.dperelygin0 = {
    primary = true;
    address = "dperelygin0@gmail.com";
    realName = "monavixx";
    userName = "dperelygin0@gmail.com";
    flavor = "gmail.com";
    enable = true;
    passwordCommand = "cat ${config.age.secrets.dp0-gmail-app-password.path}";

    aerc = {
      enable = true;
    };
    imapnotify = {
      enable = true;
      boxes = [ "INBOX" ];
      onNotifyPost = {
        notification = ''
          #!/usr/bin/env bash
          ACTION=''$(${pkgs.libnotify}/bin/notify-send -app-icon=aerc --action=default="Show" 'dperelygin0@gmail.com' 'New mail arrived')
          case "''$ACTION" in
            "default")
                uwsm app -- kitty aerc
                ;;
            esac
        '';
      };
    };
  };
  services.imapnotify.enable = true;
  programs.aerc = {
    enable = true;
    extraConfig = {
      general.unsafe-accounts-conf = true;
    };
  };
}
