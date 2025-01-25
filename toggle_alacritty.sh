#!/bin/bash

# This script will be executed by sxhkd when the hotkey is pressed
# If alacritty is not running, it will be started.
if ! pgrep -x "alacritty" > /dev/null
then
    alacritty
    exit
fi
# Otherwise it will toggle the visibility of alacritty terminal, if it is not visible, it will be shown, otherwise it will be hidden
xdotool search --class Alacritty windowactivate --sync key --clearmodifiers ctrl+grave
