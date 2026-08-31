#!/usr/bin/env bash
# Title-less Chrome --app window with a persistent profile.
# Default-profile --app windows are throwaway: Chrome drops their site data
# when that window closes. A dedicated user-data-dir keeps cookies on disk.
# Do not wrap in uwsm-app — it reuses the running Default Chrome and the
# --user-data-dir / --app flags never take effect.
set -euo pipefail

if (($# < 1)); then
  echo "Usage: $0 <url> [chrome-flags...]" >&2
  exit 1
fi

profile="${DELOREAN_CHROME_WEBAPP_DIR:-$HOME/.local/share/delorean/chrome-webapps}"
mkdir -p "$profile"

browser=$(xdg-settings get default-web-browser)
case $browser in
  google-chrome* | brave* | microsoft-edge* | opera* | vivaldi* | helium*) ;;
  *) browser="chromium.desktop" ;;
esac

bin=""
for dir in "${XDG_DATA_HOME:-$HOME/.local/share}" "$HOME/.nix-profile/share" /usr/share; do
  desktop="$dir/applications/$browser"
  if [[ -f $desktop ]]; then
    bin=$(sed -n 's/^Exec=\([^ ]*\).*/\1/p' "$desktop" | head -1)
    [[ -n $bin ]] && break
  fi
done

if [[ -z $bin ]]; then
  echo "No Chrome-family browser on PATH" >&2
  exit 1
fi

# Profile name becomes the window-class suffix (chrome-*.Delorean) so
# launch-or-focus does not raise leftover Default-profile --app windows.
exec setsid "$bin" \
  --user-data-dir="$profile" \
  --profile-directory=Delorean \
  --no-first-run \
  --no-default-browser-check \
  --hide-crash-restore-bubble \
  --app="$1" \
  "${@:2}"
