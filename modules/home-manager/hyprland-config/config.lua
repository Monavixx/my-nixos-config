hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 10,

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "master",
        border_size      = 0,
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,

        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow           = {
            enabled = true,
            color = { colors = { "rgba(ff66b55a)", "rgba(cba6f75a)" }, angle = 45 },
            color_inactive = "rgba(5959595a)",
            range = 8,
            render_power = 4
        },
        blur             = {
            enabled  = true,
            size     = 4,
            passes   = 2,
            vibrancy = 0.1696,
            special  = true
        },
    },

    animations = {
        enabled = true,
    },

    ecosystem = {
        no_donation_nag = true
    }
})
hl.config({
    master = {
        new_status = "inherit",
        mfact = 0.75,
        orientation = "left",
        focus_master_on_close = true
    },
})
hl.config({
    dwindle = {
        preserve_split = true,
    },
})
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },
})
hl.config({
    input = {
        kb_layout          = "us,ru",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "caps:escape",
        kb_rules           = "",

        follow_mouse       = 1,

        sensitivity        = 0, -- -1.0 - 1.0, 0 means no modification.

        numlock_by_default = true
    },
})
