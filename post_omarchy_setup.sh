#! /bin/sh

set -euo pipefail

cmd="./extra_app_install.sh"
exec setsid uwsm app -- alacritty --class=Omarchy-Setup --title=Omarchy-Post-Setup -e bash -c "omarchy-show-logo; $cmd; omarchy-show-done"
