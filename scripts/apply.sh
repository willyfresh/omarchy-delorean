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

if ! command -v stow >/dev/null 2>&1; then
  echo "stow is required: omarchy pkg add stow" >&2
  exit 1
fi

# Stow never owns an absolute symlink. The old linker used those.
# Drop one only when it already points at this package, then stow
# recreates it as a relative link. A relative link that already
# points at the package is left for restow. A real directory is
# folded into. Never follow a symlink: ~/.config/xkb is the package.
points_at_src() {
  local dest="$1" src="$2" target src_real
  [[ -L $dest ]] || return 1
  target="$(readlink -f "$dest" || true)"
  src_real="$(readlink -f "$src")"
  [[ -n $target && $target == "$src_real" ]]
}

prep_stow() {
  local rel="$1"
  local src="$ROOT/config/$rel"
  local dest="$HOME/.config/$rel"
  [[ -e $src || -L $src ]] || return 0
  if points_at_src "$dest" "$src"; then
    if [[ $(readlink "$dest") == /* ]]; then
      rm "$dest"
      echo "replaced absolute link: $dest"
    fi
    return 0
  fi
  if [[ -L $dest || ( -e $dest && ! -d $dest ) ]]; then
    mv "$dest" "${dest}.bak.${stamp}"
    echo "backed up ${dest} -> ${dest}.bak.${stamp}"
    return 0
  fi
  if [[ -d $dest && -d $src ]]; then
    local child base
    shopt -s nullglob dotglob
    for child in "$src"/*; do
      base="$(basename "$child")"
      [[ $base == . || $base == .. ]] && continue
      prep_stow "$rel/$base"
    done
    shopt -u nullglob dotglob
  fi
}

shopt -s nullglob dotglob
for child in "$ROOT/config"/*; do
  base="$(basename "$child")"
  [[ $base == . || $base == .. || $base == applications || $base == .stow-local-ignore ]] && continue
  prep_stow "$base"
done
shopt -u nullglob dotglob

# Package tree mirrors ~/.config. See config/.stow-local-ignore.
stow --dir="$ROOT" --target="$HOME/.config" --restow config
echo "stowed config -> $HOME/.config"

# Prefer the Delorean clock (higher-contrast date/time) over stock.
shell_json="$HOME/.config/omarchy/shell.json"
if [[ -f $shell_json ]] && command -v python3 >/dev/null 2>&1; then
  python3 - "$shell_json" <<'PY'
import json, sys
path = sys.argv[1]
with open(path) as f:
    data = json.load(f)
bar = data.setdefault("bar", {})
changed = False
if bar.get("centerAnchor") == "omarchy.clock":
    bar["centerAnchor"] = "delorean.clock"
    changed = True
for entries in (bar.get("layout") or {}).values():
    if not isinstance(entries, list):
        continue
    for entry in entries:
        if isinstance(entry, dict) and entry.get("id") == "omarchy.clock":
            entry["id"] = "delorean.clock"
            changed = True
if changed:
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
        f.write("\n")
PY
fi

# Chrome PWAs (--app-id) draw a CSD title bar. Maps/Messages use --app=URL
# via omarchy-launch-webapp instead. Copy (do not symlink) over Chrome's
# generated launchers so a Chrome rewrite cannot clobber the overlay source.
apps="$HOME/.local/share/applications"
install_desktop() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ -f "$dest" ]] && cmp -s "$src" "$dest"; then
      echo "already current: $dest"
      return
    fi
    mv "$dest" "${dest}.bak.${stamp}"
    echo "backed up ${dest} -> ${dest}.bak.${stamp}"
  fi
  cp "$src" "$dest"
  echo "installed $dest"
}

install_desktop "$ROOT/config/applications/youtube-music.desktop" \
  "$apps/chrome-cinhimbnkkaeohfgghhklpknlkffjgod-Default.desktop"
install_desktop "$ROOT/config/applications/youtube.desktop" \
  "$apps/YouTube.desktop"
install_desktop "$ROOT/config/applications/board-game-arena.desktop" \
  "$apps/chrome-pogkokppkghfaeboimdkfifmcmlhngnl-Default.desktop"
install_desktop "$ROOT/config/applications/gmail.desktop" \
  "$apps/Gmail.desktop"
install_desktop "$ROOT/config/applications/google-messages.desktop" \
  "$apps/Google Messages.desktop"
install_desktop "$ROOT/config/applications/google-maps.desktop" \
  "$apps/Google Maps.desktop"
install_desktop "$ROOT/config/applications/google-calendar.desktop" \
  "$apps/Google Calendar.desktop"
install_desktop "$ROOT/config/applications/discord.desktop" \
  "$apps/Discord.desktop"
install_desktop "$ROOT/config/applications/lazygit.desktop" \
  "$apps/Lazygit.desktop"
install_desktop "$ROOT/config/applications/yazi.desktop" \
  "$apps/yazi.desktop"
install_desktop "$ROOT/config/applications/neomutt.desktop" \
  "$apps/NeoMutt.desktop"
install_desktop "$ROOT/config/applications/concord.desktop" \
  "$apps/Concord.desktop"
install_desktop "$ROOT/config/applications/superfile.desktop" \
  "$apps/Superfile.desktop"
install_desktop "$ROOT/config/applications/lazyvim.desktop" \
  "$apps/LazyVim.desktop"

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database "$apps" >/dev/null 2>&1 || true
fi

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
