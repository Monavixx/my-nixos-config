hl.bind("ALT + SHIFT + ALT_L + SHIFT_L", hl.dsp.exec_cmd("hyprctl switchxkblayout main next"), {release = true})
hl.bind("SHIFT + ALT + SHIFT_L + ALT_L", hl.dsp.exec_cmd("hyprctl switchxkblayout main next"), {release = true})

hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("vicinae close || vicinae open"))
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("wlogout"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"));
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))

hl.bind("SUPER + Q", hl.dsp.exec_cmd("uwsm app -- kitty"))
hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + M", hl.dsp.exec_cmd("command -v uwsm >/dev/null 2>&1 && uwsm stop || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("uwsm app -- kitty yazi"))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + X",         hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + X", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true})

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

hl.bind("SUPER + CTRL + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + CTRL + left", hl.dsp.focus({ workspace = "e-1" }))

hl.bind("SUPER + tab", function ()
    local layouts     = { "dwindle", "master" }
    local workspace   = hl.get_active_workspace()
	if hl.get_active_special_workspace() then
		workspace = hl.get_active_special_workspace()
	end
    local next_layout = "dwindle"
    if not workspace then
        return
    end
    for i = 1, #layouts do
        if layouts[i] == workspace.tiled_layout then
            local next_layout_idx = (i % #layouts) + 1
            next_layout = layouts[next_layout_idx]
            break
        end
    end
	if workspace.special then
		hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
	else
		hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
	end
	if next_layout == "master" then
		hl.exec_cmd("sleep 0.05 && hyprctl dispatch 'hl.dsp.layout(\"swapwithmaster master\")'")
	end
end)

-- Workspace layout-specific binds
local function layout_bind(table)
  return function()
    local layout = hl.get_active_workspace().tiled_layout
    if table[layout] then
      hl.dispatch(table[layout])
    end
  end
end

hl.bind("SUPER + Z", layout_bind({
    dwindle = hl.dsp.layout("togglesplit")
}))
hl.bind("SUPER + S", layout_bind({
    dwindle = hl.dsp.layout("swapsplit"),
    master = hl.dsp.layout("swapwithmaster master")
}))
hl.bind("SUPER + SHIFT + up", layout_bind({
    dwindle = hl.dsp.layout("movetoroot"),
    master = hl.dsp.layout("swapprev")
}))
hl.bind("SUPER + SHIFT + down", layout_bind({
    master = hl.dsp.layout("swapnext")
}))
hl.bind("SUPER + ALT + left", layout_bind({
    dwindle = hl.dsp.layout("splitratio -0.1"),
    master = hl.dsp.layout("mfact -0.1")
}), {repeating = true})
hl.bind("SUPER + ALT + right", layout_bind({
    dwindle = hl.dsp.layout("splitratio +0.1"),
    master = hl.dsp.layout("mfact +0.1")
}), {repeating = true})

