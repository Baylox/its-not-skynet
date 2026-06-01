#!/bin/bash
# Journalise toutes les commandes Bash exécutées par Claude.
# Événement : PostToolUse — matcher: "Bash"
# Source : https://docs.anthropic.com/fr/docs/claude-code/hooks

LOG_FILE="${HOME}/.claude/bash-command-log.txt"

jq -r --arg ts "$(date -Iseconds)" \
    '"[\($ts)] \(.tool_input.command)"' \
    >> "$LOG_FILE"

exit 0
