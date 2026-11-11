hl.layer_rule({ match = { namespace = "waybar" }, blur = true })

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    match = {
        class = "^AmneziaVPN$"
    },
    workspace = "special:magic silent"
})
hl.window_rule({
    name        = "no-gaps-wtv1",
    match       = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name        = "no-gaps-f1",
    match       = { float = false, workspace = "f[1]" },
    border_size = 0,
    rounding    = 0,
})
hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


hl.window_rule({
    match = {
        class = "^reaper$"
    },
    opacity = "0.9 override",
})
hl.window_rule({
    match = {
        class = "^bruno$"
    },
    opacity = "0.8 override",
})
hl.window_rule({
    match = {
        class = "^org.telegram.desktop$"
    },
    opacity = "0.95 override",
})
hl.window_rule({
    match = {
        class = "^kitty$"
    },
    opacity = "1 override",
})
hl.window_rule({
    match = {
        class = "^obsidian$"
    },
    opacity = "0.9 override",
})
hl.window_rule({
    match = {
        class = "^google-chrome$"
    },
    opacity = "0.9 override 0.85 override 1 override"
})
