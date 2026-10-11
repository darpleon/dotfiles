-- Hyprland 0.55+ Lua configuration
-- Install as ~/.config/hypr/hyprland.lua

local terminal = "foot"
local file_manager = "thunar"
local menu = "fuzzel"
local main_mod = "SUPER"

-- Display names/modes must match `hyprctl monitors` on your machine.
hl.monitor({ output = "eDP-1", mode = "2880x1800", position = "0x0", scale = 1.5 })
hl.monitor({ output = "DP-1", mode = "3840x2160", position = "-3072x0", scale = 1.25 })
hl.monitor({ output = "DP-2", mode = "3840x2160@120", position = "-3072x0", scale = 1.25 })
-- DP-1 and DP-2 intentionally share a position: change one if both are connected.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "Adwaita:dark")

-- Permissions are disabled by default. To enforce them, explicitly enable
-- ecosystem.enforce_permissions and add rules with hl.permission(...).

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 20,
        border_size = 2,
        col = {
            active_border = "rgba(33ccffee)",
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    master = { new_status = "master" },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = false,
    },
    input = {
        kb_file = "/home/nato/.config/xkb/huprog",
        kb_layout = "huprog",
        kb_variant = "",
        kb_model = "",
        kb_options = "caps:swapescape",
        kb_rules = "",
        follow_mouse = 2,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
    },
})

local curves = {
    easeOutQuint = { { 0.23, 1 }, { 0.32, 1 } },
    easeInOutCubic = { { 0.65, 0.05 }, { 0.36, 1 } },
    linear = { { 0, 0 }, { 1, 1 } },
    almostLinear = { { 0.5, 0.5 }, { 0.75, 1 } },
    quick = { { 0.15, 0 }, { 0.1, 1 } },
}
for name, points in pairs(curves) do
    hl.curve(name, { type = "bezier", points = points })
end

local animation_specs = {
    { "global", 10, "default" },
    { "border", 5.39, "easeOutQuint" },
    { "windows", 4.79, "easeOutQuint" },
    { "windowsIn", 4.1, "easeOutQuint", "popin 87%" },
    { "windowsOut", 1.49, "linear", "popin 87%" },
    { "fadeIn", 1.73, "almostLinear" },
    { "fadeOut", 1.46, "almostLinear" },
    { "fade", 3.03, "quick" },
    { "layers", 3.81, "easeOutQuint" },
    { "layersIn", 4, "easeOutQuint", "fade" },
    { "layersOut", 1.5, "linear", "fade" },
    { "fadeLayersIn", 1.79, "almostLinear" },
    { "fadeLayersOut", 1.39, "almostLinear" },
    { "workspaces", 1.94, "almostLinear", "fade" },
    { "workspacesIn", 1.21, "almostLinear", "fade" },
    { "workspacesOut", 1.94, "almostLinear", "fade" },
    { "zoomFactor", 7, "quick" },
}
for _, spec in ipairs(animation_specs) do
    hl.animation({
        leaf = spec[1], enabled = true, speed = spec[2],
        bezier = spec[3], style = spec[4],
    })
end

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

local function bind(keys, dispatcher, flags)
    hl.bind(main_mod .. " + " .. keys, dispatcher, flags)
end
local function command(keys, cmd, flags)
    bind(keys, hl.dsp.exec_cmd(cmd), flags)
end

command("Return", terminal)
bind("SHIFT + Return", hl.dsp.exec_cmd(terminal, { float = true }))
bind("C", hl.dsp.window.close())
command("SHIFT + R", "hyprctl reload")
bind("SHIFT + Q", hl.dsp.exit())
command("E", file_manager)
bind("V", hl.dsp.window.float({ action = "toggle" }))
command("Space", menu)
bind("F", hl.dsp.window.fullscreen({ action = "toggle" }))
bind("P", hl.dsp.window.pseudo())

for key, direction in pairs({
    left = "left", right = "right", up = "up", down = "down",
    H = "left", L = "right", J = "up", K = "down",
}) do
    bind(key, hl.dsp.focus({ direction = direction }))
    bind("SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

for i = 1, 10 do
    local key = tostring(i % 10)
    bind(key, hl.dsp.focus({ workspace = i }))
    bind("SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

local scratchpad = ""
bind("S", hl.dsp.workspace.toggle_special(scratchpad))
bind("SHIFT + S", hl.dsp.window.move({ workspace = "special:" .. scratchpad }))

bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind("mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind("period", hl.dsp.focus({ workspace = "m+1" }))
bind("comma", hl.dsp.focus({ workspace = "m-1" }))
bind("SHIFT + period", hl.dsp.workspace.move({ monitor = "r" }))
bind("SHIFT + comma", hl.dsp.workspace.move({ monitor = "l" }))

hl.bind("Print", hl.dsp.exec_cmd("grimblast -f copy area"))
command("slash", "makoctl dismiss")
bind("mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("mouse:273", hl.dsp.window.resize(), { mouse = true })

local media = {
    { "XF86AudioRaiseVolume", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", true },
    { "XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", true },
    { "XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" },
    { "XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle" },
    { "XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+", true },
    { "XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-", true },
    { "XF86AudioNext", "playerctl next" },
    { "XF86AudioPause", "playerctl play-pause" },
    { "XF86AudioPlay", "playerctl play-pause" },
    { "XF86AudioPrev", "playerctl previous" },
}
for _, item in ipairs(media) do
    hl.bind(item[1], hl.dsp.exec_cmd(item[2]),
        { locked = true, repeating = item[3] == true })
end
