{ pkgs, ... }:
{
  systemd.user.timers.productivity-control = {
    Install.WantedBy = [ "timers.target" ];
    Unit.PartOf = [ "productivity-control.service" ];
    Timer.OnCalendar = "hourly";
  };
  systemd.user.services.productivity-control = {
    Unit.Description = "Hourly productivity check-in";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "productivity-control" ''
        PHRASES=("Hour's up — still on track?"
                  "Time check: what did you just finish?"
                  "60 minutes down. Next move?"
                  "Pause. Refocus. Go."
                  "Are you working or wandering?"
                  "New hour, new intention — set it."
                  "Quick check-in: on task or off track?"
                  "Tick. That's another hour gone — worth it?"
                  "Reset your focus for the next 60."
                  "Progress check: what's the next win?"
                  "What are you doing right now?"
                  "Is this what you meant to be doing?"
                  "Name the task in front of you."
                  "Is this moving you forward?"
                  "What's on your screen — and why?"
                  "Check: intentional or drifting?"
                  "What did you just get pulled into?"
                  "Is this the priority, or a distraction?"
                  "What are you avoiding right now?"
                  "Say out loud what you're working on."
                  "Does this deserve your attention?"
                  "What would you tell someone else you're doing?"
                  "Is this task or is this noise?"
                  "What's actually getting done here?"
                  "Would you choose this again, right now?"
                  "What's the one thing you should be doing?"
                  "Is this earning its place in your day?"
                  "Catch yourself — what's happening?"
                  "What just happened to your focus?"
                  "Is this on your list, or off it?")
        PHRASE=$(shuf -n 1 -e "''${PHRASES[@]}")
        notify-send -t 5000 "$PHRASE"
      ''}";
    };
  };
}
