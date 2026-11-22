{ den, ... }:
{
  den.aspects.email = {
    includes = [ den.aspects.agenix ];
    homeManager =
      {
        lib,
        user,
        pkgs,
        config,
        ...
      }:
      let
        accountName = builtins.head (lib.splitString "@" user.email);
        secretName = user.emailPasswordSecret;
        secretPath = config.age.secrets.${secretName}.path;
        getGmailPassword = pkgs.writeShellScript "get-gmail-password" ''
          exec ${pkgs.coreutils}/bin/cat -- "${secretPath}"
        '';
        syncMail = pkgs.writeShellScript "sync-gmail-mail" ''
          set -euo pipefail

          export NOTMUCH_CONFIG="${config.xdg.configHome}/notmuch/default/config"

          ${pkgs.isync}/bin/mbsync --pull --new '${accountName}:INBOX'
          ${pkgs.notmuch}/bin/notmuch new
        '';
      in
      {
        age.secrets.${secretName}.file = ../../../secrets/${secretName}.age;

        accounts.email.maildirBasePath = "maildir";
        accounts.email.accounts.${accountName} = {
          primary = true;
          address = user.email;
          realName = user.fullName;
          userName = user.email;
          flavor = "gmail.com";
          enable = true;
          passwordCommand = [ "${getGmailPassword}" ];

          maildir.path = accountName;

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
        systemd.user.services."imapnotify-${accountName}" = {
          Install.WantedBy = [ "graphical-session.target" ];
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
        programs.notmuch = {
          enable = true;
          hooks.postNew = ''
            ${pkgs.notifymuch}/bin/notifymuch
          '';
        };
        xdg.configFile."notifymuch/notifymuch.cfg".text = ''
          [notifymuch]
          query = is:unread and path:${accountName}/INBOX/**
          mail_client = ${pkgs.uwsm}/bin/uwsm app -- ${pkgs.kitty}/bin/kitty ${pkgs.aerc}/bin/aerc
          recency_interval_hours = 48
          hidden_tags = inbox unread attachment replied sent encrypted signed
        '';
        programs.aerc = {
          enable = true;
          extraConfig.general.unsafe-accounts-conf = true;
        };
      };
  };
}
