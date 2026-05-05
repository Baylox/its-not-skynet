#!/bin/bash
# Vérifie que le dernier commit ne contient pas de Co-Authored-By.
# Événement : PostToolUse — matcher: "Bash", if: "Bash(git commit *)"
# Plus fiable que PreToolUse : inspecte le message réellement enregistré.

COMMIT_MSG=$(git log -1 --format="%B" 2>/dev/null)

if echo "$COMMIT_MSG" | grep -qi 'co-authored-by'; then
    echo "Co-Authored-By détecté dans le dernier commit. Amendez le message : git commit --amend" >&2
    exit 2
fi

exit 0
