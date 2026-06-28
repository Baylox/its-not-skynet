#!/bin/bash
# pre_commit_run_doctor — bloque un `git commit` si scripts/doctor.sh échoue.
# Événement : PreToolUse — matcher: "Bash"
# Dogfooding : le repo prêche la validation, le hook l'impose.
# Déterministe, zéro réseau. Dépend de jq (parse de la commande) + scripts/ du repo.
#
# Ne s'active QUE dans un dépôt qui possède scripts/doctor.sh (its-not-skynet).
# Ailleurs, il sort en 0 sans interférer.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Ne cible que les git commit (git commit --help & co. sont sans danger).
echo "$COMMAND" | grep -qE 'git\s+commit' || exit 0

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"
[ -n "$ROOT" ] && [ -x "$ROOT/scripts/doctor.sh" ] || exit 0  # pas ce repo → on n'interfère pas

if ! out=$(cd "$ROOT" && bash scripts/doctor.sh 2>&1); then
    {
        echo "Commit bloqué : scripts/doctor.sh échoue (lint / catalogue / audit)."
        echo "Corrige les points ✗ ci-dessous, puis recommence :"
        echo "$out" | tail -25
    } >&2
    exit 2
fi

exit 0
