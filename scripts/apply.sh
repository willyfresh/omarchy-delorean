#!/usr/bin/env bash
# Symlink this repo into Omarchy user config paths. Never touches /usr/share/omarchy.
set -euo pipefail

ROOT="$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)"
APPLY_THEME=0

for arg in "$@"; do
  case "$arg" in
    --theme) APPLY_THEME=1 ;;
    -h|--help)
      echo "Usage: $0 [--theme]"
      echo "  Symlink Delorean overlay into ~/.config."
      echo "  --theme  also run: omarchy theme set delorean"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

stamp="$(date +%s)"

link() {
  local src="$1" dest="$2"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -L "$dest" ]] && [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
      echo "already linked: $dest"
      return
    fi
    mv "$dest" "${dest}.bak.${stamp}"
    echo "backed up ${dest} -> ${dest}.bak.${stamp}"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

link "$ROOT/config/hypr/bindings.lua" "$HOME/.config/hypr/bindings.lua"
link "$ROOT/config/hypr/input.lua" "$HOME/.config/hypr/input.lua"
link "$ROOT/config/xkb" "$HOME/.config/xkb"
link "$ROOT/config/omarchy/themes/delorean" "$HOME/.config/omarchy/themes/delorean"

if command -v hyprctl >/dev/null 2>&1; then
  hyprctl reload
  errors="$(hyprctl configerrors 2>/dev/null || true)"
  if [[ -n "${errors}" && "${errors}" != "no errors" ]]; then
    echo "hyprctl configerrors:" >&2
    echo "${errors}" >&2
    exit 1
  fi
  echo "hyprland reload: ok"
else
  echo "hyprctl not on PATH; skip reload"
fi

if (( APPLY_THEME )); then
  omarchy theme set delorean
fi
