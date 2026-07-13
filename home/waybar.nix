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
        "modules-center" = ["hyprland/window" "custom/music"];
        "modules-right" = ["pulseaudio" "backlight" "battery" "clock" "tray" "custom/lock" "custom/power"];
        "hyprland/workspaces" = {
            #"on-scroll-up" = "hyprctl dispatch 'hl.dsp.focus({workspace=\"e+1\"})' ";
            #"on-scroll-down" = "hyprctl dispatch 'hl.dsp.focus({workspace=\"e-1\"})' ";
            "format" = " {icon} ";
            "format-icons" = {
                "default" = "";
            };
            "on-click" = "activate";
            "tooltips" = {
                "default" = "{name}: {windows}";
                "empty" = "";
            };
        };
        "hyprland/window" = {
            "separate-outputs" = true;
            tooltip = false;
        };
        "tray" = {
            "icon-size" = 17;
            "spacing" = 10;
        };
        "custom/music" = {
            "format" = "  {}";
            "escape" = true;
            "interval" = 5;
            "tooltip" = false;
            "exec" = "playerctl metadata --format='{{ title }}'";
            "on-click" = "playerctl play-pause";
            "max-length" = 50;
        };
        "clock" = {
            "timezone" = "Europe/Moscow";
            "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            "format-alt" = " {:%d/%m/%Y}";
            "format" = " {:%H:%M}";
        };
        "backlight" = {
            "device" = "intel_backlight";
            "format" = "{icon}";
            "format-icons" = ["" "" "" "" "" "" "" "" ""];
            tooltip = false;
        };
        "battery" = {
            "states" = {
                "warning" = 30;
                "critical" = 15;
            };
            "format" = "{icon}";
            "format-charging" = "";
            "format-plugged" = "";
            "format-alt" = "{icon}";
            "format-icons" = ["" "" "" "" "" "" "" "" "" "" "" ""];
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
    background: transparent;
    color: @text;
    margin: 5px 5px;
    }

    #workspaces {
    border-radius: 1rem;
    margin: 5px;
    background-color: @surface0;
    margin-left: 1rem;
    }

    #workspaces button {
    color: @lavender;
    border-radius: 1rem;
    padding: 0.4rem;
    }

    #workspaces button.active {
    color: @sky;
    border-radius: 1rem;
    }

    #workspaces button:hover {
    color: @sapphire;
    border-radius: 1rem;
    }

    #custom-music,
    #tray,
    #backlight,
    #clock,
    #battery,
    #pulseaudio,
    #custom-lock,
    #custom-power {
    background-color: @surface0;
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

    #battery.warning:not(.charging) {
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
