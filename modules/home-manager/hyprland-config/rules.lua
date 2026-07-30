hl.layer_rule({ match = { namespace = "waybar" }, blur = true })

 hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
 hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
 hl.window_rule({
     name  = "no-gaps-wtv1",
     match = { float = false, workspace = "w[tv1]" },
     border_size = 0,
     rounding    = 0,
 })
hl.window_rule({
     name  = "no-gaps-f1",
     match = { float = false, workspace = "f[1]" },
     border_size = 0,
     rounding    = 0,
 })
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})


hl.layer_rule({
    match = {
        namespace = "^vicinae$"
    },
    blur = true;
})
hl.window_rule({
    match = {
        class = "^vicinae$"
    },
    opacity = "0.7",
})
hl.window_rule({
    match = {
        class = "^bruno$"
    },
    opacity = "0.8",
})
hl.window_rule({
    match = {
        class = "^org.telegram.desktop$"
    },
    opacity = "0.95",
})
hl.window_rule({
    match = {
        class = "^obsidian$"
    },
    opacity = "0.9",
})
hl.window_rule({
    match = {
        class = "^jetbrains-rider$"
    },
    opacity = "0.9"
})
hl.window_rule({
    match = {
        class = "^jetbrains",
        float = true
    },
    stay_focused = true
})
hl.window_rule({
    match = {
        class = "^code$"
    },
    opacity = "0.88"
})
hl.window_rule({
    match = {
        class = "^google-chrome$"
    },
    opacity = "0.9 0.85 1 override"
})
