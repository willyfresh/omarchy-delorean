#!/usr/bin/env bash
# Make the webapp Chrome user-data-dir a single signed-in Default profile.
# Links out of --app windows open in that dir's Default; an empty Default
# is the logged-out Chrome. Stop webapp Chrome first.
set -euo pipefail

dir="${DELOREAN_CHROME_WEBAPP_DIR:-$HOME/.local/share/delorean/chrome-webapps}"

if [[ ${1:-} == --quit ]]; then
  pkill -f "user-data-dir=${dir}" || true
  for _ in {1..50}; do
    pgrep -f "user-data-dir=${dir}" >/dev/null || break
    sleep 0.1
  done
  shift
fi

if pgrep -f "user-data-dir=${dir}" >/dev/null; then
  echo "webapp Chrome is still running; close it or pass --quit" >&2
  exit 1
fi

if [[ ! -d $dir/Delorean ]]; then
  echo "No $dir/Delorean to collapse" >&2
  exit 0
fi

if [[ -d $dir/Default ]]; then
  bak="$dir/Default.unsigned.$(date +%s)"
  mv "$dir/Default" "$bak"
  echo "parked empty Default -> $bak"
fi

mv "$dir/Delorean" "$dir/Default"
echo "Delorean -> Default"

python3 - "$dir" <<'PY'
import json, sys
from pathlib import Path

root = Path(sys.argv[1])
state_path = root / "Local State"
state = json.loads(state_path.read_text())
profile = state.setdefault("profile", {})
cache = profile.setdefault("info_cache", {})
if "Delorean" in cache:
    cache["Default"] = cache.pop("Delorean")
    cache["Default"]["name"] = cache["Default"].get("name") or "Person 1"
profile["last_used"] = "Default"
profile["last_active_profiles"] = ["Default"]
state_path.write_text(json.dumps(state))
print("Local State: last_used=Default")
PY
