#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# source https://wiki.archlinux.org/title/Hyprland#Using_a_script_to_change_wallpaper_every_X_minutes

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script uses bash (not POSIX shell) for the RANDOM variable

SCRIPTSDIR=$HOME/.config/hypr/scripts
UserScripts=$HOME/.config/hypr/UserScripts

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
  echo "Usage:
	$0 <dir containing images>"
  exit 1
fi

# Ensure single running instance
pidfile="${XDG_RUNTIME_DIR:-/tmp}/hypr-wallpaper-autochange.pid"
if [[ -f "$pidfile" ]]; then
  old_pid=$(cat "$pidfile" 2>/dev/null || true)
  if [[ -n "$old_pid" && "$old_pid" != "$$" ]] && kill -0 "$old_pid" 2>/dev/null; then
    kill "$old_pid" 2>/dev/null || true
  fi
fi
echo $$ > "$pidfile"

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_TYPE=simple

# This controls (in seconds) when to switch to the next image
INTERVAL=1800

while true; do
  focused_monitor=$(hyprctl monitors -j 2>/dev/null | jq -r '.[] | select(.focused) | .name' 2>/dev/null || hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')
  [[ -z "$focused_monitor" ]] && focused_monitor="eDP-1"

  find "$1" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) |
    while read -r img; do
      echo "$((RANDOM % 1000)):$img"
    done |
    sort -n | cut -d':' -f2- |
    while read -r img; do
      awww img -o "$focused_monitor" "$img"

      # Regenerate colors from the exact image path
      # WallustSwww.sh handles Wallust generation and safe waybar reloading
      "${SCRIPTSDIR}/WallustSwww.sh" "$img"

      # Refresh UI components
      pkill rofi 2>/dev/null || true
      if pgrep -x qs >/dev/null 2>&1; then
        pkill qs && qs -c overview & 2>/dev/null || true
      fi
      sleep 0.2
      swaync-client --reload-config 2>/dev/null || true

      if [[ -x "${UserScripts}/RainbowBorders.sh" ]]; then
        "${UserScripts}/RainbowBorders.sh" &
      fi

      sleep "$INTERVAL"
    done
done
