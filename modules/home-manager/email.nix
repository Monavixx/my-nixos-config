{
  pkgs,
  config,
  ...
}:
let
  secretPath = config.age.secrets.dp0-gmail-app-password.path;
  getGmailPassword = pkgs.writeShellScript "get-gmail-password" ''
    exec ${pkgs.coreutils}/bin/cat -- "${secretPath}"
  '';
  # Synchronize remote mail, then update the Notmuch database.
  syncMail = pkgs.writeShellScript "sync-gmail-mail" ''
    set -euo pipefail

    export NOTMUCH_CONFIG="${config.xdg.configHome}/notmuch/default/config"

    ${pkgs.isync}/bin/mbsync --pull --new 'dperelygin0:INBOX'
    ${pkgs.notmuch}/bin/notmuch new
  '';
  # newEmailNotify = pkgs.writeShellScript "new-email-notify" ''
  #   set -a
  #   source <(/run/current-system/sw/bin/systemctl --user show-environment)
  #   set +a
  #
  #   ACTION=''$(${pkgs.libnotify}/bin/notify-send --app-icon=aerc --action=default="Show" 'dperelygin0@gmail.com' 'New mail arrived')
  #   case "''$ACTION" in
  #     "default")
  #         ${pkgs.uwsm}/bin/uwsm app -- ${pkgs.kitty}/bin/kitty ${pkgs.aerc}/bin/aerc
  #         ;;
  #     esac
  # '';
in
{
  accounts.email.maildirBasePath = "maildir";
  accounts.email.accounts.dperelygin0 = {
    primary = true;
    address = "dperelygin0@gmail.com";
    realName = "monavixx";
    userName = "dperelygin0@gmail.com";
    flavor = "gmail.com";
    enable = true;
    passwordCommand = [ "${getGmailPassword}" ];

    maildir.path = "dperelygin0";

    folders = {
      inbox = "INBOX";
      sent = "[Gmail]/Sent Mail";
      drafts = "[Gmail]/Drafts";
      trash = "[Gmail]/Trash";
    };
    mbsync = {
      enable = true;
      create = "maildir";

      patterns = [
        "INBOX"
        "[Gmail]/Sent Mail"
        "[Gmail]/Drafts"
        "[Gmail]/Trash"
      ];
    };
    notmuch.enable = true;
    aerc.enable = true;

    imapnotify = {
      enable = true;
      boxes = [ "INBOX" ];
      onNotify = "${syncMail}";
    };
  };
  systemd.user.services.imapnotify-dperelygin0 = {
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Unit = {
      After = [
        "graphical-session.target"
        "agenix.service"
      ];
      PartOf = [
        "graphical-session.target"
        "agenix.service"
      ];
    };
  };
  services.imapnotify.enable = true;
  programs.mbsync.enable = true;
  # Local indexing and notification generation
  programs.notmuch = {
    enable = true;

    hooks.postNew = ''
      ${pkgs.notifymuch}/bin/notifymuch
    '';
  };
  # Desktop notification configuration
  xdg.configFile."notifymuch/notifymuch.cfg".text = ''
    [notifymuch]
    query = is:unread and path:dperelygin0/INBOX/**
    mail_client = ${pkgs.uwsm}/bin/uwsm app -- ${pkgs.kitty}/bin/kitty ${pkgs.aerc}/bin/aerc
    recency_interval_hours = 48
    hidden_tags = inbox unread attachment replied sent encrypted signed
  '';
  programs.aerc = {
    enable = true;
    extraConfig = {
      general.unsafe-accounts-conf = true;
    };
  };
}
