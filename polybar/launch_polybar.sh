#!/bin/bash
killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep l; done
polybar top --config=~/.config/polybar/config.ini &
#if type "xrandr"; then
#  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
#    MONITOR=$m polybar --reload top &
 #   MONITOR=$m polybar --reload bottom &
  #done
#else
 # polybar --reload top &
 # polybar --reload bottom &
#fi
