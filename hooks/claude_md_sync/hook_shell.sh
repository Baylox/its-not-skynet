#!/bin/bash
# Vérifie si des ressources ont été ajoutées sans mise à jour des docs.
# Événement : PostToolUse — matcher: "Bash", if: "Bash(git commit *)"
# Type : command (shell pur, zéro token)

CHANGED=$(git diff --name-only HEAD~1 HEAD 2>/dev/null)

RESOURCES=$(echo "$CHANGED" | grep -E '^(hooks|skills|configs)/' | grep -v 'README\.md$')
DOCS=$(echo "$CHANGED" | grep -E '(CLAUDE\.md|README\.md)')

if [[ -n "$RESOURCES" && -z "$DOCS" ]]; then
    echo "Des ressources ont été modifiées dans hooks/, skills/ ou configs/ sans mise à jour de CLAUDE.md ou d'un README.md." >&2
    exit 2
fi

exit 0
