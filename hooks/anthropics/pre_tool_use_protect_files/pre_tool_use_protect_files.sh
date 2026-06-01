#!/bin/bash
# Bloque l'édition de fichiers sensibles (Edit/Write).
# Événement : PreToolUse — matcher: "Edit|Write"
# Source : https://docs.anthropic.com/fr/docs/claude-code/hooks
# Exit 2 = blocage avec message d'erreur dans stderr

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

PROTECTED_PATTERNS=(".env" "package-lock.json" ".git/")

for pattern in "${PROTECTED_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == *"$pattern"* ]]; then
        echo "Bloqué : $FILE_PATH correspond au pattern protégé '$pattern'" >&2
        exit 2
    fi
done

exit 0
