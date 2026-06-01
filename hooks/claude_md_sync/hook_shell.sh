#!/bin/bash
# Vérifie si de nouvelles ressources ont été ajoutées sans mise à jour des docs.
# Événement : PostToolUse — matcher: "Bash", if: "Bash(git commit *)"
# Type : command (shell pur, zéro token)
# --diff-filter=A : uniquement les fichiers nouvellement ajoutés (pas les modifs)

ADDED=$(git diff --diff-filter=A --name-only HEAD~1 HEAD 2>/dev/null)

NEW_RESOURCES=$(echo "$ADDED" | grep -E '^(hooks|skills|configs)/' | grep -vE '(README\.md|META\.md)$')
DOCS=$(echo "$ADDED" | grep -E '(CLAUDE\.md|README\.md)')

if [[ -n "$NEW_RESOURCES" && -z "$DOCS" ]]; then
    echo "De nouvelles ressources ont été ajoutées dans hooks/, skills/ ou configs/ sans mise à jour de CLAUDE.md ou d'un README.md." >&2
    exit 2
fi

exit 0
