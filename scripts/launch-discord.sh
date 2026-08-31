#!/usr/bin/env bash
# Focus a real Discord window. The updater splash is also class "discord",
# so omarchy-launch-or-focus with ^discord$ raises the updater and looks dead.
set -euo pipefail

address="$(hyprctl clients -j | jq -r '
  .[]
  | select((.class // "" | ascii_downcase) == "discord")
  | select((.title // "" | ascii_downcase) | contains("updater") | not)
  | .address
' | head -n1)"

if [[ -n "${address}" ]]; then
  hyprctl dispatch "hl.dsp.focus({ window = \"address:${address}\" })" >/dev/null 2>&1 \
    || hyprctl dispatch focuswindow "address:${address}"
  exit 0
fi

exec setsid uwsm-app -- discord
