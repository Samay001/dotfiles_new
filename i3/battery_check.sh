#!/bin/bash

# Get battery percentage
battery_level=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

# Check if battery is below 20% and not charging
if [[ "$battery_level" -le 65 && "$status" == "Discharging" ]]; then
    notify-send "⚠ Low Battery" "Battery is at ${battery_level}%. Please plug in your charger." --urgency=critical
fi
