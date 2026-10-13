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

# Function to spawn dropterm
spawn_dropterm() {
  debug_echo "Spawning $DROPTERM_CLASS"
  hyprctl dispatch exec "$TERMINAL_EXEC" >/dev/null 2>&1

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
    hyprctl dispatch movetoworkspacesilent "$STORAGE_WS,address:$ADDR" >/dev/null 2>&1
    exit 0
  else
    # Interactively spawned: pin and focus on current workspace
    CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')
    hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:$ADDR" >/dev/null 2>&1
    hyprctl dispatch pin "address:$ADDR" >/dev/null 2>&1
    hyprctl dispatch focuswindow "address:$ADDR" >/dev/null 2>&1
    exit 0
  fi
fi

# If already running and called silently, ensure it is parked
if [ "$SILENT" = true ]; then
  hyprctl dispatch movetoworkspacesilent "$STORAGE_WS,address:$ADDR" >/dev/null 2>&1
  exit 0
fi

# Terminal is running: check its state
CLIENT=$(get_dropterm_client)
IS_PINNED=$(echo "$CLIENT" | jq -r '.pinned')
TERM_WS=$(echo "$CLIENT" | jq -r '.workspace.name')
FOCUSED_ADDR=$(hyprctl activewindow -j | jq -r '.address')
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.id')

debug_echo "ADDR=$ADDR, PINNED=$IS_PINNED, WS=$TERM_WS, FOCUSED=$FOCUSED_ADDR, CURRENT_WS=$CURRENT_WS"

if [ "$TERM_WS" != "$STORAGE_WS" ]; then
  # Dropterm is currently visible on screen: HIDE it
  debug_echo "Hiding dropterm to $STORAGE_WS"
  if [ "$IS_PINNED" = "true" ]; then
    hyprctl dispatch pin "address:$ADDR" >/dev/null 2>&1
  fi
  hyprctl dispatch movetoworkspacesilent "$STORAGE_WS,address:$ADDR" >/dev/null 2>&1
else
  # Dropterm is hidden in storage workspace: SHOW it on the CURRENT workspace
  debug_echo "Showing dropterm on current workspace $CURRENT_WS"
  hyprctl dispatch movetoworkspacesilent "$CURRENT_WS,address:$ADDR" >/dev/null 2>&1
  hyprctl dispatch pin "address:$ADDR" >/dev/null 2>&1
  hyprctl dispatch focuswindow "address:$ADDR" >/dev/null 2>&1
fi
