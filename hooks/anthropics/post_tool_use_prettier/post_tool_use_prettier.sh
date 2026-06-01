#!/bin/bash
# Auto-formate les fichiers après écriture avec Prettier.
# Événement : PostToolUse — matcher: "Edit|Write"
# Prérequis : npx disponible dans le PATH
# Source : https://docs.anthropic.com/fr/docs/claude-code/hooks

FILE_PATH=$(jq -r '.tool_input.file_path // empty')

if [[ -z "$FILE_PATH" ]]; then
    exit 0
fi

npx prettier --write "$FILE_PATH" 2>/dev/null

exit 0
