#!/bin/bash
# block_push_main — bloque tout `git push` vers main/master.
# Événement : PreToolUse — matcher: "Bash"
# Cohérent avec la règle de branches du repo : on développe sur une branche dédiée,
# main reste protégée (merge via PR uniquement).
# Déterministe, zéro réseau. Dépend de jq (parse de la commande).

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Ne cible que les git push.
echo "$COMMAND" | grep -qE 'git\s+push' || exit 0

block() {
    {
        echo "Push bloqué : main/master est protégée."
        echo "Pousse sur une branche dédiée et passe par une PR."
    } >&2
    exit 2
}

# 1) Cible explicite main/master dans la commande (word boundary : 'maintenance' OK).
echo "$COMMAND" | grep -qiE 'git\s+push\b[^|;&]*\b(main|master)\b' && block

# 2) Push sans refspec explicite (git push | git push origin | git push -u origin) :
#    on regarde la branche courante — si c'est main/master, le push y va.
rest=$(echo "$COMMAND" | sed -E 's/.*git[[:space:]]+push//')
positional=$(echo "$rest" | tr ' ' '\n' | grep -vE '^-' | grep -cE '.')
if [ "$positional" -le 1 ]; then
    ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel 2>/dev/null)}"
    branch=$(git -C "${ROOT:-.}" symbolic-ref --short HEAD 2>/dev/null)
    case "$branch" in
        main|master) block ;;
    esac
fi

exit 0
