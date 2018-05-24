#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run chromium
run caprine
run discord
run thunderbird

# Background
run zeal
run dropbox
run copyq
run albert

run nm-applet
run megasync
run pasystray
