-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Custom
require('awful.remote')
-- require('screenful')

local rule_tags = require("rule_tags")

local vicious = require("vicious")

-- local cpu_widget = require('awesome-wm-widgets.cpu-widget.cpu-widget')
-- local ram_widget = require('awesome-wm-widgets.ram-widget.ram-widget')
-- local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local battery_widget = require('awesome-wm-widgets.battery-widget.battery')
-- local printer_jobs_widget = require('printer-jobs-widget')
-- local unread_emails_widget = require('unread-emails-widget')
-- local bluetooth_headset_battery_widget = require('bluetooth-headset-battery-widget')

local function spawn_focus_cwd(program)
  if client.focus and client.focus.pid ~= nil then
    awful.spawn.with_shell('cd "$(readlink /proc/"$(pgrep -P ' .. client.focus.pid .. ' | tail -1)"/cwd)"; ' .. program)
  else
    awful.spawn.with_shell(program)
  end
end

local info_ids = {}
local function show_info_text(text, id)
  local noti = naughty.notify({
    text = text,
    font = "monospace",
    position = "top_middle",
    replaces_id = info_ids[id],
    timeout = 1,
  })
  if noti ~= nil then
    info_ids[id] = noti.id
  end
end

local function show_bar(fraction, tick, id)
  local total_ticks = 20
  local ticks = math.floor(fraction * total_ticks)
  local bar = string.rep(tick, ticks) .. string.rep(" ", total_ticks - ticks)
  show_info_text("[" .. bar .. "]", id)
end

local function show_volume()
  local fd = io.popen("pamixer --get-mute --get-volume")
  local status = fd:read("*all")
  fd:close()

  local word_gen = string.gmatch(status, "[^%s]+")
  local mute_status = word_gen()
  local volume_str = word_gen()

  local volume = tonumber(volume_str)

  if mute_status == "false" then
    show_bar(volume / 100, "#", "volume")
  else
    show_info_text(string.rep("M", 22), "volume")
  end
end

local function get_number_output(cmd)
  local fd = io.popen(cmd)
  local output = fd:read("*all")
  fd:close()

  return tonumber(output)
end

local max_brightness = get_number_output("brightnessctl max")
local brightness_step
if max_brightness ~= nil then
  brightness_step = max_brightness / 10
end

local function get_brightness()
  return get_number_output("brightnessctl get")
end

local function show_brightness()
  show_bar(get_brightness() / max_brightness, "o", "brightness")
end

local function set_brightness(value)
  if value < 0 then
    value = 0
  end
  awful.spawn.easy_async("brightnessctl set " .. math.floor(value + 0.5), show_brightness)
end

local function step_brightness(diff)
  local step = math.floor(get_brightness() / brightness_step)
  set_brightness((step + diff) * brightness_step)
end

local function increase_brightness()
  local b = get_brightness()
  if b == 0 then
    set_brightness(1)
  else
    step_brightness(1)
  end
end

local function decrease_brightness()
  local b = get_brightness()
  if 1 < b and b <= brightness_step + 0.5 then
    set_brightness(1)
  else
    step_brightness(-1)
  end
end

--[[
local assault = require('assault.awesomewm.assault')
local battery_widget = assault({
    critical_level = 0.15,
    critical_color = "#ff0000",
    charging_color = "#00ff00"
})
]]

local calendar = require("calendar")

awful.util.shell = '/bin/bash'

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

awful.spawn.with_shell("pgrep flameshot || dex -a")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme = dofile(gears.filesystem.get_themes_dir() .. "default/theme.lua")
theme.wallpaper = "~/.config/awesome/background.png"
beautiful.init(theme)

-- Only works in awesome 4.3 or later:
beautiful.notification_icon_size = 100

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- battery warning
-- created by bpdp

local function trim(s)
  return s:find'^%s*$' and '' or s:match'^%s*(.*%S)'
end

local function bat_notification()

  local f_capacity = assert(io.open("/sys/class/power_supply/BAT0/capacity", "r"))
  local f_status = assert(io.open("/sys/class/power_supply/BAT0/status", "r"))

  local bat_capacity = tonumber(f_capacity:read("*all"))
  local bat_status = trim(f_status:read("*all"))

  if (bat_capacity <= 10 and bat_status == "Discharging") then
    naughty.notify({ title      = "Battery Warning"
      , text       = "Battery low! " .. bat_capacity .."%" .. " left!"
      , fg="#ff0000"
      , bg="#deb887"
      , timeout    = 15
      , position   = "bottom_left"
    })
  end
end

battimer = timer({timeout = 120})
battimer:connect_signal("timeout", bat_notification)
battimer:start()

-- end here for battery warning

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
separator = wibox.widget {
  widget = wibox.widget.separator,
  orientation = vertical,
  forced_width = 10,
}

-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %a %b %d, %H:%M:%S ", 1)
calendar({}):attach(mytextclock)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        -- gears.wallpaper.maximized(wallpaper, s, false)
        gears.wallpaper.centered(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    local is_primary = s == screen.primary

    awful.tag(rule_tags.get_tagnames(is_primary), s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            separator,
            -- unread_emails_widget,
            -- printer_jobs_widget,
            -- cpu_widget,
            -- ram_widget,
            -- volume_widget,
            -- bluetooth_headset_battery_widget,
            seperator,
            battery_widget,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)

screen.connect_signal("list", awesome.restart)
screen.connect_signal("primary_changed", awesome.restart)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return",
    function ()
      spawn_focus_cwd(terminal)
    end,
              {description = "open a terminal", group = "launcher"}),

    --[[
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    ]]--

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),

    -- Custom modkey + space
    awful.key({ modkey,           }, "space", function () awful.spawn.with_shell("albert toggle") end,
              {description = "select next", group = "layout"}),

    awful.key({ modkey,           }, "a", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = gears.filesystem.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() awful.spawn("dmenu_extended_run") end,
              {description = "show the menubar", group = "launcher"}),

     --[[

121 XF86AudioMute
122 XF86AudioLowerVolume
123 XF86AudioRaiseVolume
173 XF86AudioPrev
172 XF86AudioPlay
171 XF86AudioNext
73  F7
133 Super_L
225 XF86Search
232 XF86MonBrightnessDown
233 XF86MonBrightnessUp
107 Print
118 Insert
119 Delete

     --]]

     awful.key({ modkey }, "c", function() awful.spawn.with_shell("firefox-developer-edition") end,
              {description = "open firefox", group = "custom"}),
     awful.key({ modkey }, "d", function() spawn_focus_cwd("nautilus .") end,
              {description = "open nautilus", group = "custom"}),

      -- Volume Keys
      awful.key({}, "XF86AudioLowerVolume", function ()
        awful.spawn.easy_async("pamixer --decrease 5", show_volume)
      end),
      awful.key({}, "XF86AudioRaiseVolume", function ()
        awful.spawn.easy_async("pamixer --increase 5", show_volume)
      end),
      awful.key({}, "XF86AudioMute", function ()
        awful.spawn.easy_async("pamixer --toggle-mute", show_volume)
      end),
      -- Media Keys
      awful.key({}, "XF86AudioPlay", function()
        awful.spawn("playerctl play-pause", false)
      end),
      awful.key({}, "XF86AudioNext", function()
        awful.spawn("playerctl next", false)
      end),
      awful.key({}, "XF86AudioPrev", function()
        awful.spawn("playerctl previous", false)
      end),

     -- Brightness
     awful.key({}, "F7", function()
       awful.spawn.with_shell("$HOME/bin/toggle_screen", false)
     end,
              {description = "toggle screen and keyboard backlight", group = "custom"}),

     awful.key({}, "XF86MonBrightnessDown", decrease_brightness,
              {description = "decrease screen brightness", group = "custom"}),

     awful.key({}, "XF86MonBrightnessUp", increase_brightness,
              {description = "increase screen brightness", group = "custom"}),

    -- Print screen
     awful.key({}, "Print", function() awful.spawn.with_shell("flameshot gui") end,
              {description = "take screenshot", group = "custom"}),

     -- awful.key({}, "Super_L", function() awful.spawn.with_shell("xrandr --auto") end,
     --         {description = "xrandr auto", group = "custom"}),

     awful.key({ modkey }, ";", function() awful.spawn.with_shell("xset s activate") end,
              {description = "lock computer", group = "custom"}),
     awful.key({ modkey, "Shift" }, ";", function() awful.spawn.with_shell("systemctl suspend") end,
              {description = "suspend computer", group = "custom"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "f",
        function (c)
            if c.floating then
               c.floating = false
               return
            end

            c.floating = true
            local geo = {}
            geo.x = screen[1].geometry.x
            geo.y = screen[1].geometry.y
            geo.width = screen[1].geometry.width
            geo.height = screen[1].geometry.height
            geo.x2 = geo.x + geo.width
            geo.y2 = geo.y + geo.height
            for s in screen do
                local geo2 = s.geometry
                geo.x = math.min(geo.x, geo2.x)
                geo.y = math.min(geo.y, geo2.y)
                geo.x2 = math.max(geo.x2, geo2.x + geo2.width)
                geo.y2 = math.max(geo.y2, geo2.y + geo2.height)
            end
            c:geometry{
                x = geo.x,
                y = geo.y,
                width = geo.x2 - geo.x,
                height = geo.y2 - geo.y
            }
        end,
    {description = "toggle all monitor fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "mpv",
          "mplayer",

          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",

          "MEGAsync",
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    { rule_any = {
        class = {
          "albert",
          "Ulauncher",
        },
      }, properties = { border_width = 0 },
    },

    -- Always show on top
    { rule_any = {
        class = {
          "hearthstonedecktracker.exe"
        },
        name = {
          "HearthstoneOverlay",
          "hearthstonedecktracker.exe",
          "overwolf.exe",
          "The HearthArena.com Overwolf App",
        },
      },
      properties = {
        ontop = true,
      }
    },

    -- Fix for IntelliJ IDEs
    { rule = {
        class = "jetbrains-.*",
        instance = "sun-awt-X11-XWindowPeer",
        name = "win.*",
    },
      properties = {
        floating = true,
        focus = true,
        focusable = false,
        ontop = true,
        placement = awful.placement.restore,
        buttons = {},
     }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

function extend(t1, t2)
    return table.move(t2, 1, #t2, #t1 + 1, t1)
end

extend(awful.rules.rules, rule_tags.get_rules())

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
