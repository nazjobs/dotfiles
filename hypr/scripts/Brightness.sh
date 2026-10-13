#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for Monitor backlights (if supported) using brightnessctl

iDIR="$HOME/.config/swaync/icons"
notification_timeout=1000
step=10 # INCREASE/DECREASE BY THIS VALUE

# Get current brightness as an integer (without %)
get_brightness() {
  brightnessctl -m | cut -d, -f4 | tr -d '%'
}

# Determine the icon based on brightness level
get_icon_path() {
  local brightness=$1
  local level=$(((brightness + 19) / 20 * 20)) # Round up to next 20
  if ((level < 20)); then
    level=20
  fi
  if ((level > 100)); then
    level=100
  fi
  echo "$iDIR/brightness-${level}.png"
}

# Send notification
send_notification() {
  local brightness=$1
  local icon_path=$2

  notify-send -e \
    -h string:x-canonical-private-synchronous:brightness_notif \
    -h int:value:"$brightness" \
    -u low \
    -i "$icon_path" \
    "Screen" "Brightness: ${brightness}%"
}

# Increase brightness by 5%
increase_brightness() {
  local current new icon
  current=$(get_brightness)
  new=$((current + 5))
  ((new > 100)) && new=100

  brightnessctl set "${new}%"
  icon=$(get_icon_path "$new")
  send_notification "$new" "$icon"
}

# Decrease brightness by 5% down to 5%, then by 1% down to 0%
decrease_brightness() {
  local current new icon
  current=$(get_brightness)

  if ((current > 5)); then
    new=$((current - 5))
    ((new < 5)) && new=5
  else
    new=$((current - 1))
    ((new < 0)) && new=0
  fi

  brightnessctl set "${new}%"
  icon=$(get_icon_path "$new")
  send_notification "$new" "$icon"
}

# Main
case "$1" in
"--get")
  get_brightness
  ;;
"--inc")
  increase_brightness
  ;;
"--dec")
  decrease_brightness
  ;;
*)
  get_brightness
  ;;
esac
