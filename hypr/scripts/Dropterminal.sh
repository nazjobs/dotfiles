#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Dropdown Terminal Manager for Hyprland
# Drops down directly onto the active workspace from the top with background dimming.

DROPTERM_CLASS="kitty-dropterm"
STORAGE_WS="special:dropterm"
DEFAULT_CMD="kitty --class $DROPTERM_CLASS"

# Clean up legacy address file
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

# Function to get dropterm client JSON
get_dropterm_client() {
  hyprctl clients -j | jq -c --arg CLASS "$DROPTERM_CLASS" '.[] | select(.class == $CLASS)' | head -n1
}

# Function to get currently active special workspace (if any)
get_active_special() {
  hyprctl monitors -j | jq -r '.[] | select(.focused) | .specialWorkspace.name | select(. != "" and . != "special:dropterm")' 2>/dev/null | head -n1
}

# Hyprland 0.57+ Lua dispatch helpers
dispatch_move_silent() {
  local ws="$1"
  local addr="$2"
  local ws_val
  if [[ "$ws" =~ ^-?[0-9]+$ ]]; then
    ws_val="$ws"
  else
    ws_val="'$ws'"
  fi
  hyprctl dispatch "hl.dsp.window.move({ workspace = $ws_val, follow = false, window = 'address:$addr' })" >/dev/null 2>&1
}

dispatch_pin() {
  local addr="$1"
  hyprctl dispatch "hl.dsp.window.pin({ window = 'address:$addr' })" >/dev/null 2>&1
}

dispatch_focus() {
  local addr="$1"
  hyprctl dispatch "hl.dsp.focus({ window = 'address:$addr' })" >/dev/null 2>&1
}

dispatch_unfullscreen() {
  local addr="$1"
  hyprctl dispatch "hl.dsp.window.fullscreen_state({ internal = 0, client = 0, window = 'address:$addr' })" >/dev/null 2>&1
}

# Function to spawn dropterm
spawn_dropterm() {
  debug_echo "Spawning $DROPTERM_CLASS"
  hyprctl dispatch "hl.dsp.exec_cmd('$TERMINAL_EXEC')" >/dev/null 2>&1

  local addr=""
  for _ in {1..40}; do
    addr=$(get_dropterm_addr)
    if [ -n "$addr" ] && [ "$addr" != "null" ]; then
      debug_echo "Spawned: $addr"
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

  # If invoked silently (e.g. boot startup), park it into storage workspace
  if [ "$SILENT" = true ]; then
    debug_echo "Parking dropterm into $STORAGE_WS at boot"
    dispatch_move_silent "$STORAGE_WS" "$ADDR"
    exit 0
  else
    # Interactively spawned: animate and focus on current workspace
    ACTIVE_SPECIAL=$(get_active_special)
    if [ -n "$ACTIVE_SPECIAL" ]; then
      CURRENT_WS="$ACTIVE_SPECIAL"
    else
      CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    fi
    dispatch_move_silent "$CURRENT_WS" "$ADDR"
    if [ -z "$ACTIVE_SPECIAL" ]; then
      dispatch_pin "$ADDR"
    fi
    dispatch_focus "$ADDR"
    dispatch_unfullscreen "$ADDR"
    exit 0
  fi
fi

# If already running and called silently, ensure it is parked
if [ "$SILENT" = true ]; then
  dispatch_move_silent "$STORAGE_WS" "$ADDR"
  exit 0
fi

# Terminal is running: check its state
CLIENT=$(get_dropterm_client)
IS_PINNED=$(echo "$CLIENT" | jq -r '.pinned')
TERM_WS=$(echo "$CLIENT" | jq -r '.workspace.name')
FOCUSED_ADDR=$(hyprctl activewindow -j | jq -r '.address')
ACTIVE_SPECIAL=$(get_active_special)

AT_X=$(echo "$CLIENT" | jq -r '.at[0] // empty')
AT_Y=$(echo "$CLIENT" | jq -r '.at[1] // empty')
HEIGHT=$(echo "$CLIENT" | jq -r '.size[1] // empty')

if [ -z "$AT_X" ] || [ -z "$HEIGHT" ]; then
  mon_w=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .width / .scale' | awk '{print int($1)}')
  AT_X=$(( mon_w * 175 / 1000 ))
  HEIGHT=550
  TARGET_Y=30
else
  TARGET_Y=${AT_Y:-30}
  if [ "$TARGET_Y" -lt 0 ]; then
    TARGET_Y=30
  fi
fi
OFFSCREEN_Y=$(( -HEIGHT - 60 ))

debug_echo "ADDR=$ADDR, PINNED=$IS_PINNED, WS=$TERM_WS, SPECIAL=$ACTIVE_SPECIAL, X=$AT_X, Y=$TARGET_Y"

if [ "$TERM_WS" != "$STORAGE_WS" ]; then
  # Dropterm is currently visible on screen: HIDE it with slide-up animation
  debug_echo "Hiding dropterm to $STORAGE_WS with slide-up"
  hyprctl dispatch "hl.dsp.window.move({ x = $AT_X, y = $OFFSCREEN_Y, window = 'address:$ADDR' })" >/dev/null 2>&1
  sleep 0.22
  if [ "$IS_PINNED" = "true" ]; then
    dispatch_pin "$ADDR"
  fi
  dispatch_move_silent "$STORAGE_WS" "$ADDR"

  # If user was in a special workspace, ensure it remained active
  if [ -n "$ACTIVE_SPECIAL" ]; then
    cur_sp=$(get_active_special)
    if [ "$cur_sp" != "$ACTIVE_SPECIAL" ]; then
      hyprctl dispatch "hl.dsp.workspace.toggle_special('${ACTIVE_SPECIAL#special:}')" >/dev/null 2>&1
    fi
  fi
else
  # Dropterm is hidden in storage workspace: SHOW it with slide-down animation
  if [ -n "$ACTIVE_SPECIAL" ]; then
    CURRENT_WS="$ACTIVE_SPECIAL"
  else
    CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
  fi

  debug_echo "Showing dropterm on workspace $CURRENT_WS with slide-down"
  # Place offscreen above before revealing
  hyprctl dispatch "hl.dsp.window.move({ x = $AT_X, y = $OFFSCREEN_Y, window = 'address:$ADDR' })" >/dev/null 2>&1
  dispatch_move_silent "$CURRENT_WS" "$ADDR"
  if [ -z "$ACTIVE_SPECIAL" ]; then
    dispatch_pin "$ADDR"
  fi
  # Slide down into view
  hyprctl dispatch "hl.dsp.window.move({ x = $AT_X, y = $TARGET_Y, window = 'address:$ADDR' })" >/dev/null 2>&1
  dispatch_focus "$ADDR"
  dispatch_unfullscreen "$ADDR"
fi
