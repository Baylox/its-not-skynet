#!/bin/bash
# Bloque l'écriture de secrets en dur et le commit de fichiers sensibles.
# Événement : PreToolUse — matcher: "Edit|Write|Bash"
# Exit 2 = blocage avec message dans stderr.
#
# Déterministe, aucune dépendance réseau. Requiert : jq dans le PATH.

INPUT=$(cat)

TOOL=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // empty')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Patterns de secrets en dur (clé = valeur). Volontairement conservateur
# pour limiter les faux positifs.
SECRET_PATTERNS=(
    'aws_secret_access_key[[:space:]]*=[[:space:]]*[A-Za-z0-9/+=]{20,}'
    'AKIA[0-9A-Z]{16}'                                  # AWS access key id
    'sk-[A-Za-z0-9]{20,}'                               # clés type OpenAI
    'sk-ant-[A-Za-z0-9_-]{20,}'                         # clés Anthropic
    'ghp_[A-Za-z0-9]{36}'                               # GitHub personal token
    'xox[baprs]-[A-Za-z0-9-]{10,}'                      # tokens Slack
    '-----BEGIN[[:space:]]+[A-Z]*[[:space:]]*PRIVATE KEY-----'  # clés privées
    '(password|passwd|secret|api_?key|token)[[:space:]]*[:=][[:space:]]*["'\''][^"'\'' ]{8,}["'\'']'
)

# 1) Écriture de contenu (Edit/Write) : scan du contenu inséré
if [[ -n "$CONTENT" ]]; then
    for pattern in "${SECRET_PATTERNS[@]}"; do
        if echo "$CONTENT" | grep -qiE "$pattern"; then
            echo "Bloqué : secret potentiel en dur détecté dans $FILE_PATH (pattern: ${pattern%%[*}...)." >&2
            echo "Utilise une variable d'environnement ou un gestionnaire de secrets." >&2
            exit 2
        fi
    done
fi

# 2) Commit git d'un .env (ou variantes) via Bash
if [[ -n "$COMMAND" ]] && echo "$COMMAND" | grep -qE 'git[[:space:]]+(add|commit)'; then
    if echo "$COMMAND" | grep -qE '(^|[[:space:]/])\.env(\.[A-Za-z]+)?([[:space:]]|$)'; then
        echo "Bloqué : tentative d'ajout/commit d'un fichier .env. Ajoute-le plutôt à .gitignore." >&2
        exit 2
    fi
fi

exit 0
