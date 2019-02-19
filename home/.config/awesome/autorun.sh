#!/usr/bin/env bash

function run {
  if ! pgrep --full --ignore-case "$1" > /dev/null; then
    "$@" &
  fi
}

cmds=(
# Compositor
"compton"

# Programs with dedicated tabs
"zeal"
"caprine"
"thunderbird"

# Chromium is nice to have running
"chromium"

# Task bar programs
"fluxgui"
"nm-applet"
"pasystray"
"megasync"
"copyq"
"albert"
"udiskie --tray"
"caffeine"
"flameshot"
)

for cmd in "${cmds[@]}"; do
  run $cmd
done
