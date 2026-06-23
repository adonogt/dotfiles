-- minimal hyprland config for the greetd regreet session

-- both monitors configured explicitly
-- the start-greeter.sh script disables eDP-1 if HDMI-A-1 is connected
hl.monitor({ output = "eDP-1",    mode = "1920x1080@60", position = "0x0",    scale = 1.5  })
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60", position = "1280x0", scale = 1    })
hl.monitor({ output = "",         mode = "preferred",     position = "auto",   scale = "auto" })

hl.on("hyprland.start", function()
    hl.exec_cmd("/etc/greetd/start-greeter.sh")
end)

hl.config({
    misc = {
        disable_hyprland_logo           = true,
        disable_splash_rendering        = true,
        disable_hyprland_guiutils_check = true,
        force_default_wallpaper         = 0,
    },
    decoration = {
        blur   = { enabled = false },
        shadow = { enabled = false },
    },
    animations = { enabled = false },
})
