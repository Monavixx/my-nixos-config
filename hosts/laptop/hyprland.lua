hl.monitor({
    output   = "",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1.25",
})

hl.device({
    name = "htix5288:00-093a:0255-touchpad",
    natural_scroll = true
})


hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})
hl.gesture({
    fingers = 3,
    direction = "down",
    action = function()
        hl.exec_cmd("playerctl play-pause")
    end
})
local volume_gesture = function(change) hl.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ " .. math.abs(change) .. "%" .. (change<0 and "-" or "+")) end
hl.gesture({
  fingers = 4,
  direction = "vertical",
  action = {
    start = function(e) volume_gesture(-0.25 * e.delta.y) end,
    update = function(e) volume_gesture(-0.25 * e.delta.y) end
  }
})
hl.gesture({
    fingers = 4,
    direction = "right",
    action = function()
        hl.exec_cmd("playerctl next")
    end
})
hl.gesture({
    fingers = 4,
    direction = "left",
    action = function()
        hl.exec_cmd("playerctl previous")
    end
})

hl.bind("switch:Lid Switch", hl.dsp.exec_cmd("hyprlock"));

hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })