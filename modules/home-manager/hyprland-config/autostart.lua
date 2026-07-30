hl.on("hyprland.start", function ()
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- AmneziaVPN")
    hl.exec_cmd("uwsm app -- google-chrome")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("uwsm app -- awww-daemon")
end)

hl.window_rule({
    match = {
        class = "^AmneziaVPN$"
    },
    workspace = "special:magic silent"
})
