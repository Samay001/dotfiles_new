#!/bin/bash

picom &
sh ~/.config/polybar/launch.sh
polybar top -c ~/.config/polybar/config.ini &
# polybar top -c ~/.config/polybar/config.ini &
# nitrogen --restore &
# ~/Downloads/Mechvibes-2.3.6-hotfix.AppImage &

