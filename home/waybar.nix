{ ... }:
{
 programs.waybar = {
  enable = true;
  #settings = {
  #  mainBar = {
  #    layer = "top";
  #    position = "top";
  #    modules-left = ["hyprland/workspaces"];
  #    modules-center = ["clock"];
  #    modules-right = ["pulseaudio" "battery"];
  #  };
  #};
  settings = {
    mainBar = {
        "layer" = "top";
        "position" = "top";
        "modules-left" = ["hyprland/workspaces"];
        "modules-center" = ["hyprland/window" ]; #"custom/music"];
        "modules-right" = ["pulseaudio" "backlight" "battery" "network" "clock" "tray" "custom/lock" "custom/power"];
        "hyprland/workspaces" = {
            "format" = " {icon} ";
            "format-icons" = {
                "default" = "";
            };
        };
        "network" = {
            "format" = "{ifname}"; 
            "format-wifi" = "{icon}";
            "format-ethernet" = "󰣺";
            "format-disconnected" = "󰤮";
            "format-icons" = [
                "󰤯"
                "󰤟"
                "󰤢"
                "󰤥"
                "󰤨"
            ];
            "tooltip-format" = "{ifname}";
            "tooltip-format-wifi" = "{essid} {icon}";
            "tooltip-format-ethernet" = "{ifname} 󰣺";
            "tooltip-format-disconnected" = "Disconnected";
            "on-click" = "kitty nmtui";
        };
        "hyprland/window" = {
            "separate-outputs" = true;
            tooltip = false;
            "max-length" = 40;
        };
        "tray" = {
            "icon-size" = 17;
            "spacing" = 10;
        };
        #"custom/music" = {
        #    "format" = "  {}";
        #    "escape" = true;
        #    "interval" = 5;
        #    "tooltip" = false;
        #    "exec" = "playerctl metadata --format='{{ title }}'";
        #    "on-click" = "playerctl play-pause";
        #    "max-length" = 50;
        #};
        "clock" = {
            "tooltip-format" = "<big>{:%d/%m/%Y}</big>\n<tt><small>{calendar}</small></tt>";
            "format" = "{:%I:%M %p %d %B}";
            "calendar" = {
                "mode"             = "year";
                "mode-mon-col"     = 3;
                "on-click-right"   = "mode";
                "format" = {
                    "months" =     "<span color='#ffead3'><b>{}</b></span>";
                    "days" =       "<span color='#ecc6d9'><b>{}</b></span>";
                    "weeks" =      "<span color='#99ffdd'><b>W{}</b></span>";
                    "weekdays" =   "<span color='#ffcc66'><b>{}</b></span>";
                    "today" =      "<span color='#fcbeff' background='#ff5757'><b>{}</b></span>";
                };
            };
        };
        "backlight" = {
            "device" = "intel_backlight";
            "format" = "{icon}";
            "format-icons" = ["" "" "" "" "" "" "" "" ""];
            tooltip = false;
        };
        "battery" = {
            "format" = "{capacity}% {icon}";
            "tooltip-format" = "{timeTo}";
            "states" = {
                "warning" = 30;
                "critical" = 15;
            };
            "events" = {
                "on-discharging-warning" = "notify-send -u normal 'Low Battery'";
                "on-discharging-critical" = "notify-send -u critical 'Very Low Battery'";
            };
            "format-icons" = {
                "default" = ["" "" "" "" ""];
                "charging" = ["󱐋" "󱐋" "󱐋" "󱐋" "󱐋"];
            };
            "max-length" = 6;
        };
        "pulseaudio" = {
            "scroll-step" = 1;
            "reverse-scroll" = true;
            "reverse-mouse-scrolling" = true;
            "format" = "{volume}% {icon}";
            "min-length" = 5;
            "format-muted" = "";
            "format-icons" = {
                "default" = ["" "" " "];
            };
            "on-click" = "pavucontrol";
        };
        "custom/lock" = {
            "tooltip" = false;
            "on-click" = "hyprlock & disown";
            "format" = "";
        };
        "custom/power" = {
            "tooltip" = false;
            "on-click" = "wlogout &";
            "format" = "";
        };
    };
  };
  style = ''
    * {
    font-family: FantasqueSansM Nerd Font;
    font-size: 15px;
    min-height: 0;
    }

    #waybar {
    background: linear-gradient(
        to bottom, 
        rgba(0, 0, 0, 0.3) 0%, 
        rgba(0, 0, 0, 0.0) 100%
    );
    color: @text;
    margin: 5px 5px;
    }

    #workspaces {
    border-radius: 1rem;
    margin: 5px;
    background: linear-gradient(
        to bottom, 
        alpha(@surface0, 0.8) 0%,
        alpha(@surface0, 0.5) 100%
    );
    margin-left: 1rem;
    }

    #workspaces button {
    color: @lavender;
    border-radius: 1rem;
    padding: 0.4rem;
    }

    #workspaces button.active {
    color: @sky;
    border-radius: 50%;
    background: linear-gradient(
        to bottom, 
        alpha(@surface1, 0.8) 0%,
        alpha(@surface1, 0.5) 100%
    );
    }

    #workspaces button:hover {
    color: @sapphire;
    border-radius: 1rem;
    }

    #network,
    #custom-music,
    #tray,
    #backlight,
    #clock,
    #battery,
    #pulseaudio,
    #custom-lock,
    #custom-power {
    background: linear-gradient(
        to bottom, 
        alpha(@surface0, 0.8) 0%,
        alpha(@surface0, 0.5) 100%
    );
    padding: 0.5rem 1rem;
    margin: 5px 0;
    }

    #clock {
    color: @blue;
    border-radius: 0px 1rem 1rem 0px;
    margin-right: 1rem;
    }

    #battery {
    color: @green;
    }

    #battery.charging {
    color: @green;
    }

    #battery.warning:not(.charging),
    #battery.critical:not(.charging) {
    color: @red;
    }

    #backlight {
    color: @yellow;
    }

    #backlight, #battery {
        border-radius: 0;
    }

    #pulseaudio {
    color: @maroon;
    border-radius: 1rem 0px 0px 1rem;
    margin-left: 1rem;
    }

    #custom-music {
    color: @mauve;
    border-radius: 1rem;
    }

    #custom-lock {
        border-radius: 1rem 0px 0px 1rem;
        color: @lavender;
    }

    #custom-power {
        margin-right: 1rem;
        border-radius: 0px 1rem 1rem 0px;
        color: @red;
    }

    #tray {
    margin-right: 1rem;
    border-radius: 1rem;
    }
  '';
 };
}
