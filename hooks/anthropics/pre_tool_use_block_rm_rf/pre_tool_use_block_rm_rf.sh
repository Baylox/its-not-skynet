#!/bin/bash
# Bloque les commandes rm -rf dangereuses.
# Événement : PreToolUse — matcher: "Bash"
# Source : https://docs.anthropic.com/fr/docs/claude-code/hooks
# Exit 2 = blocage avec message d'erreur dans stderr

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if echo "$COMMAND" | grep -qE 'rm\s+-[a-zA-Z]*r[a-zA-Z]*f|rm\s+-[a-zA-Z]*f[a-zA-Z]*r'; then
    echo "Bloqué : commande rm -rf interdite : $COMMAND" >&2
    exit 2
fi

exit 0
