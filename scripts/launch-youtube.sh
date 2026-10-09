#!/usr/bin/env bash
# Super+Shift+Y: YouTube Music and YouTube. Music comes first.
# Focused music goes to YouTube. Focused YouTube comes back to music.
# From anywhere else: focus music, or YouTube if only that is open, or launch music.
set -euo pipefail

ROOT="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

focus_window() {
  local address="$1"
  hyprctl dispatch "hl.dsp.focus({ window = \"address:${address}\" })" >/dev/null 2>&1 \
    || hyprctl dispatch focuswindow "address:${address}"
}

read -r action target <<<"$(python3 - <<'PY' || true
import json, subprocess, sys

windows = json.loads(subprocess.check_output(["hyprctl", "clients", "-j"], text=True))

def cls(w):
    return (w.get("class") or "").lower()

def is_music(w):
    return "chrome-music.youtube.com" in cls(w)

def is_youtube(w):
    c = cls(w)
    if "chrome-music.youtube.com" in c:
        return False
    return "chrome-www.youtube.com" in c or c.startswith("chrome-youtube.com")

def hist(w):
    return w.get("focusHistoryID") if w.get("focusHistoryID") is not None else 999

music = sorted((w for w in windows if is_music(w)), key=hist)
video = sorted((w for w in windows if is_youtube(w)), key=hist)
music_focus = bool(music) and hist(music[0]) == 0
video_focus = bool(video) and hist(video[0]) == 0

if music_focus:
    if video:
        print("focus", video[0]["address"])
    else:
        print("launch youtube")
elif video_focus:
    if music:
        print("focus", music[0]["address"])
    else:
        print("launch music")
elif music:
    print("focus", music[0]["address"])
elif video:
    print("focus", video[0]["address"])
else:
    print("launch music")
PY
)"

case "${action:-}" in
  focus)
    focus_window "$target"
    ;;
  launch)
    if [[ "$target" == "youtube" ]]; then
      exec "$ROOT/launch-webapp.sh" "https://www.youtube.com/"
    fi
    exec "$ROOT/launch-webapp.sh" "https://music.youtube.com/"
    ;;
  *)
    exec "$ROOT/launch-webapp.sh" "https://music.youtube.com/"
    ;;
esac
