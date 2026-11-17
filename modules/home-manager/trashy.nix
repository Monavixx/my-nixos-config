{ inputs, pkgs, ... }:
{
  home.packages = [ inputs.trashy.defaultPackage.${pkgs.system} ];
  home.shellAliases = {
    rm = "echo 'Use tp instead. Use \\\\rm for permanent deletion.'; false";
    tp = "trashy put";
    trash-put = "trashy put";
    trash-list = "trashy list";
    trash-restore = "trashy restore";
    trash-empty = "trashy empty";
  };

  systemd.user.services.trash-cleanup = {
    Unit.Description = "Clean trash older than 30 days";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.trash-cli}/bin/trash-empty 30";
      ExecStartPost = "${pkgs.libnotify}/bin/notify-send 'Trash cleanup' 'Removed items older than 30 days'";
    };
  };

  systemd.user.timers.trash-cleanup = {
    Unit.Description = "Daily trash cleanup";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
    };

    Install.WantedBy = [ "timers.target" ];
  };
}
