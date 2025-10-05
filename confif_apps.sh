#! /bin/sh

set -euo pipefail

ICON_DIR="$HOME/.local/share/applications/icons"
mkdir -p "$ICON_DIR"

install-tui(){
  APP_NAME="$1"
  APP_EXEC="$2"
  WINDOW_STYLE="$3"
  ICON="$4"
  omarchy-tui-install "$APP_NAME" "$APP_EXEC" "$WINDOW_STYLE" "./icons/$ICON"
  cp "./icons/$ICON" "$ICON_DIR/$ICON"
}

# RMPC Music Player
APP_NAME="RMPC Music Player"
install-tui "$APP_NAME" rmpc float "music.png"


