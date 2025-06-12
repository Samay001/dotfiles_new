#!/bin/bash

# Fetch the currently playing song
player_status=$(playerctl --player=chrome status 2>/dev/null)
if [ "$player_status" == "Playing" ] || [ "$player_status" == "Paused" ]; then
  artist=$(playerctl --player=chrome metadata xesam:artist 2>/dev/null)
  title=$(playerctl --player=chrome metadata xesam:title 2>/dev/null)
  echo "$artist - $title"
else
  echo "No music playing"
fi
