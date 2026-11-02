#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly

notif="$HOME/.config/swaync/images"

ENABLED=$(hyprctl -j getoption decoration:blur:enabled | jq -r ".bool")
PASSES=$(hyprctl -j getoption decoration:blur:passes | jq -r ".int")

if [ "${ENABLED}" = "false" ]; then
	hyprctl eval 'hl.config({ decoration = { blur = { enabled = true, size = 3, passes = 1 } } }); hl.dispatch(hl.dsp.force_renderer_reload())'
	notify-send -e -u low -i "$notif/note.png" " Blur: Low"
elif [ "${PASSES}" -eq 1 ]; then
	hyprctl eval 'hl.config({ decoration = { blur = { enabled = true, size = 5, passes = 2 } } }); hl.dispatch(hl.dsp.force_renderer_reload())'
	notify-send -e -u low -i "$notif/ja.png" " Blur: Normal"
elif [ "${PASSES}" -eq 2 ]; then
	hyprctl eval 'hl.config({ decoration = { blur = { enabled = true, size = 8, passes = 3 } } }); hl.dispatch(hl.dsp.force_renderer_reload())'
	notify-send -e -u low -i "$notif/ja.png" " Blur: High"
elif [ "${PASSES}" -eq 3 ]; then
	hyprctl eval 'hl.config({ decoration = { blur = { enabled = true, size = 12, passes = 4 } } }); hl.dispatch(hl.dsp.force_renderer_reload())'
	notify-send -e -u low -i "$notif/ja.png" " Blur: Translucent (Max)"
else
	hyprctl eval 'hl.config({ decoration = { blur = { enabled = false, size = 5, passes = 2 } } }); hl.dispatch(hl.dsp.force_renderer_reload())'
	notify-send -e -u low -i "$notif/note.png" " Blur: Off"
fi
