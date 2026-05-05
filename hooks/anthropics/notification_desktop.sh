#!/bin/bash
# Envoie une notification desktop quand Claude Code a besoin d'attention.
# Événement : Notification
# Source : https://docs.anthropic.com/fr/docs/claude-code/hooks

MESSAGE="Claude Code a besoin de votre attention"
TITLE="Claude Code"

if command -v osascript &>/dev/null; then
    osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
elif command -v notify-send &>/dev/null; then
    notify-send "$TITLE" "$MESSAGE"
elif command -v powershell.exe &>/dev/null; then
    powershell.exe -Command "
        [System.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
        [System.Windows.Forms.MessageBox]::Show('$MESSAGE', '$TITLE')
    "
fi
