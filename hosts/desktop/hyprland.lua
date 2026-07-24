hl.monitor({
    output   = "",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
})

hl.config({
    cursor = {
        no_hardware_cursors = 1,
        inactive_timeout = 0
    }
})

hl.device({
    name = "a4tech-usb-device",
    sensitivity = 0.5,
    accel_profile = "adaptive"
})

hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME", "nvidia")


-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
