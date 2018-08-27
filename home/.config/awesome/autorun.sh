#!/usr/bin/env bash

function run {
  if ! pgrep --full --ignore-case "$1" > /dev/null; then
    "$@" &
  fi
}

cmds=(
# Programs with dedicated tabs
"zeal"
"caprine"
"discord"
"slack"
"thunderbird"

# Chromium is nice to have running
"chromium"

# Task bar programs
"nm-applet"
"pasystray"
"megasync"
"copyq"
"albert"
"udiskie --tray"
"caffeine"
"emoji-keyboard"
)

for cmd in "${cmds[@]}"; do
  run $cmd
done
