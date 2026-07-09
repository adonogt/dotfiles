-- hyprland.lua


-- monitors ────────────────────────────────────────────────────────────────────

-- eDP-1 logical width = 1920 / 1.2 = 1600, so HDMI-A-1 must start at x=1600
hl.monitor({ output = "eDP-1",    mode = "1920x1080@60", position = "0x0",    scale = 1.2 })
hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@60", position = "1600x0", scale = 1    })
hl.monitor({ output = "",         mode = "preferred",     position = "auto",   scale = "auto" })


-- programs ────────────────────────────────────────────────────────────────────

local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "fuzzel"


-- autostart ───────────────────────────────────────────────────────────────────

hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("~/.config/hypr/scripts/monitor-hotplug.sh")
end)


-- environment ─────────────────────────────────────────────────────────────────

hl.env("XCURSOR_SIZE",    "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_IM_MODULE",    "fcitx")
hl.env("XMODIFIERS",      "@im=fcitx")


-- look and feel ───────────────────────────────────────────────────────────────

hl.config({
    general = {
        gaps_in          = 5,
        gaps_out         = 20,
        border_size      = 2,
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",

        col = {
            active_border   = "rgba(686868bb)",
            inactive_border = "rgba(282828aa)",
        },
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled  = true,
            size     = 4,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    animations = { enabled = true },
})


-- animations ──────────────────────────────────────────────────────────────────

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default"       })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint"  })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy"          })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear"  })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear"  })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick"         })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint"  })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear"  })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear"  })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick"         })


-- workspaces ──────────────────────────────────────────────────────────────────

-- 1-2 → eDP-1 (thinkpad), 3-5 → HDMI-A-1 (dell)
hl.workspace_rule({ workspace = "1", monitor = "eDP-1",    default = true })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1"                    })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1"                 })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1"                 })


-- layouts ─────────────────────────────────────────────────────────────────────

hl.config({ dwindle   = { preserve_split = true             } })
hl.config({ master    = { new_status     = "master"         } })
hl.config({ scrolling = { fullscreen_on_one_column = true   } })


-- misc ────────────────────────────────────────────────────────────────────────

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})


-- input ───────────────────────────────────────────────────────────────────────

hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "ctrl:nocaps",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad = { natural_scroll = false },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })


-- keybindings ─────────────────────────────────────────────────────────────────

local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + D",      hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mod .. " + J",      hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd("kitty -e bluetui"))
hl.bind(mod .. " + W",      hl.dsp.exec_cmd("kitty -e impala"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + M",      hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- screenshots
hl.bind("Print",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty -f - --copy-command wl-copy --output-filename ~/media/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim - | satty -f - --copy-command wl-copy --output-filename ~/media/pictures/screenshots/$(date +%Y%m%d_%H%M%S).png'))

-- focus
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- workspace switch and move
for i = 1, 10 do
    local key = i % 10
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- scratchpad
hl.bind(mod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- mouse
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- media
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),    { locked = true })


-- rules ───────────────────────────────────────────────────────────────────────

hl.layer_rule({ name = "waybar-blur", match = { namespace = "waybar" }, blur = true })

hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
