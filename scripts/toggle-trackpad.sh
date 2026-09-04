#!/usr/bin/env bash
# Toggle the P50 clickpad only. The TrackPoint and its three buttons stay.
# Stock omarchy-toggle-touchpad looks for a device name matching
# touchpad|trackpad; this Synaptics is synaptics-tm3149-002, so Fn / Hardware
# → Touchpad are no-ops. Persist in the same file Omarchy reloads on start.
set -euo pipefail

ACTION="${1:-toggle}"
LABEL="Touchpad"
ICON="touchpad"
NAME_FILE="$HOME/.local/state/omarchy/toggles/hypr/touchpad-disabled-name"
FALLBACK="synaptics-tm3149-002"

device=$(hyprctl devices -j | jq -r '
  [.mice[]
    | .name
    | select(test("synaptics|touchpad|trackpad"; "i"))
    | select(test("trackpoint"; "i") | not)
  ] | first // empty
')
device="${device:-$FALLBACK}"

if [[ -z $device || $device == *[[:cntrl:]]* ]]; then
  echo "No trackpad device found" >&2
  exit 1
fi

apply_device() {
  local enabled=$1
  local quoted=${device//\\/\\\\}
  quoted=${quoted//\"/\\\"}
  hyprctl eval "hl.device({ name = \"$quoted\", enabled = $enabled })" >/dev/null
}

enable() {
  rm -f "$NAME_FILE"
  apply_device true
  omarchy-osd -i "$ICON" -m "$LABEL enabled"
}

disable() {
  apply_device false
  mkdir -p "$(dirname "$NAME_FILE")"
  printf '%s\n' "$device" >"$NAME_FILE"
  omarchy-osd -i "$ICON" -m "$LABEL disabled"
}

case "$ACTION" in
  on) enable ;;
  off) disable ;;
  toggle) if [[ -f $NAME_FILE ]]; then enable; else disable; fi ;;
  *)
    echo "Usage: $0 [on|off|toggle]" >&2
    exit 1
    ;;
esac
