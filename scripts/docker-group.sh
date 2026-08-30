#!/usr/bin/env bash
# Add this account to the docker group so `docker` works without sudo.
# Needs a visible terminal for the password prompt. Takes effect after a new login.
set -euo pipefail

SELF="$(readlink -f "$0")"

if [[ "${1:-}" != "--in-window" ]]; then
  if command -v omarchy-launch-terminal >/dev/null 2>&1; then
    omarchy-launch-terminal bash "$SELF" --in-window
  else
    xdg-terminal-exec bash "$SELF" --in-window
  fi
  exit 0
fi

USER_NAME="${SUDO_USER:-$USER}"

echo "=============================================="
echo " Delorean — docker group"
echo " Type your sudo password here when asked."
echo "=============================================="
echo

if ! getent group docker >/dev/null; then
  echo "No docker group on this machine. Install Docker first:"
  echo "  omarchy pkg add docker"
  echo
  echo "Press Enter to close."
  read -r
  exit 1
fi

if id -nG "$USER_NAME" | grep -qw docker; then
  echo "$USER_NAME is already in the docker group."
  echo "This session still needs a new login (or a reboot) to pick it up."
  echo
  echo "Press Enter to close."
  read -r
  exit 0
fi

echo "Adding $USER_NAME to the docker group."
echo "Membership is root-equivalent while the Docker daemon is running."
sudo usermod -aG docker "$USER_NAME"

echo
echo "Done. Log out and back in (or reboot) before docker works without sudo."
echo "Press Enter to close."
read -r
