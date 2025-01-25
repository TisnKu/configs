#!/bin/bash

# Script to add an application to startup in Manjaro
# Usage: ./add-to-startup.sh <app-name> <app-command>

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <app-name> <app-command>"
    exit 1
fi

APP_NAME=$1
APP_COMMAND=$2
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/$APP_NAME.desktop"

# Create the autostart directory if it doesn't exist
mkdir -p "$AUTOSTART_DIR"

# Create the .desktop file
echo "[Desktop Entry]
Type=Application
Exec=$APP_COMMAND
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=$APP_NAME
Comment=Start $APP_NAME on login
" > "$DESKTOP_FILE"

# Check if the .desktop file was created successfully
if [ -f "$DESKTOP_FILE" ]; then
    echo "Successfully added '$APP_NAME' to startup."
    echo "Desktop file created at: $DESKTOP_FILE"
else
    echo "Failed to create the desktop file."
    exit 1
fi
