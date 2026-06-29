#!/bin/bash
# Supprime la ligne Co-Authored-By des messages de commit git.
# Événement : PreToolUse — matcher: "Bash"
# Filtre uniquement les appels git commit.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'git\s+commit'; then
    if echo "$COMMAND" | grep -qi 'co-authored-by'; then
        echo "Bloqué : Co-Authored-By interdit dans les commits." >&2
        exit 2
    fi
fi

exit 0
