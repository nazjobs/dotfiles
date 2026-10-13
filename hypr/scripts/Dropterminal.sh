#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Dropdown Terminal Manager for Hyprland
# Smooth hardware-accelerated special workspace dropdown with strict class targeting.

DROPTERM_CLASS="kitty-dropterm"
SPECIAL_WS="special:dropterm"
DEFAULT_CMD="kitty --class $DROPTERM_CLASS"

# Clean up legacy address file if present
rm -f /tmp/dropdown_terminal_addr

DEBUG=false
SILENT=false

for arg in "$@"; do
  case "$arg" in
    -d|--debug)
      DEBUG=true
      ;;
    -s|--silent|--init)
      SILENT=true
      ;;
    *)
      if [ -n "$arg" ] && [ "$arg" != "kitty" ] && [ "$arg" != "ghostty" ] && [ "$arg" != "alacritty" ] && [ "$arg" != "\$term" ]; then
        CUSTOM_CMD="$arg"
      fi
      ;;
  esac
done

debug_echo() {
  if [ "$DEBUG" = true ]; then
    echo "$@"
  fi
}

TERMINAL_EXEC="${CUSTOM_CMD:-$DEFAULT_CMD}"

# Function to get dropterm window address
get_dropterm_addr() {
  hyprctl clients -j | jq -r --arg CLASS "$DROPTERM_CLASS" '.[] | select(.class == $CLASS) | .address' | head -n1
}

# Function to spawn dropdown terminal into special workspace
spawn_dropterm() {
  debug_echo "Spawning $DROPTERM_CLASS using: $TERMINAL_EXEC"
  hyprctl dispatch exec "[workspace $SPECIAL_WS silent] $TERMINAL_EXEC" >/dev/null 2>&1

  # Wait for window to appear (up to 2 seconds in 50ms intervals)
  local addr=""
  for _ in {1..40}; do
    addr=$(get_dropterm_addr)
    if [ -n "$addr" ] && [ "$addr" != "null" ]; then
      debug_echo "Found window: $addr"
      return 0
    fi
    sleep 0.05
  done

  debug_echo "Timeout waiting for $DROPTERM_CLASS"
  return 1
}

ADDR=$(get_dropterm_addr)

# If not running, spawn it
if [ -z "$ADDR" ] || [ "$ADDR" = "null" ]; then
  if ! spawn_dropterm; then
    exit 1
  fi
  ADDR=$(get_dropterm_addr)
fi

# If invoked silently (e.g. pre-warmed at boot), exit now
if [ "$SILENT" = true ]; then
  debug_echo "Silent init complete"
  exit 0
fi

# Multi-monitor support: if focused monitor differs from window monitor, move it
if [ -n "$ADDR" ]; then
  focused_mon=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .id' 2>/dev/null)
  win_mon=$(hyprctl clients -j | jq -r --arg CLASS "$DROPTERM_CLASS" '.[] | select(.class == $CLASS) | .monitor' 2>/dev/null | head -n1)
  if [ -n "$focused_mon" ] && [ -n "$win_mon" ] && [ "$focused_mon" != "$win_mon" ]; then
    debug_echo "Moving dropterm to focused monitor $focused_mon"
    hyprctl dispatch movetoworkspacesilent "$SPECIAL_WS,address:$ADDR" >/dev/null 2>&1
  fi
fi

# Toggle the special workspace natively (smooth GPU-accelerated slide animation)
debug_echo "Toggling $SPECIAL_WS"
hyprctl dispatch togglespecialworkspace dropterm >/dev/null 2>&1

# Focus the terminal if special workspace is currently active
active_special=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .specialWorkspace.name' 2>/dev/null)
if [ "$active_special" = "$SPECIAL_WS" ] && [ -n "$ADDR" ]; then
  hyprctl dispatch focuswindow "address:$ADDR" >/dev/null 2>&1
fi
