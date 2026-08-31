#!/usr/bin/env bash
# Focus an existing title-less webapp, or launch it into the persistent profile.
set -euo pipefail

if (($# < 2)); then
  echo "Usage: $0 <window-pattern> <url> [chrome-flags...]" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
WINDOW_PATTERN="$1"
shift

exec omarchy-launch-or-focus "$WINDOW_PATTERN" "$ROOT/launch-webapp.sh $*"
