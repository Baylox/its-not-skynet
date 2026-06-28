#!/bin/bash
# scripts/new.sh — scaffolde une nouvelle ressource selon les conventions du repo.
# Shell pur, zéro réseau. La ressource générée démarre TOUJOURS en statut draft
# (mandat CLAUDE.md : pas de commit avant test en conditions réelles).
#
# Usage : new.sh [--root <dir>] <type> <contributeur> <nom>
#   type         hooks|skills|configs|subagents|architecture
#   contributeur pseudo (ex: Baylox)
#   nom          validé contre la convention du type (snake_case ou kebab-case)
#   --root       racine du repo où créer la ressource (défaut : repo courant)
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$DIR/.." && pwd))"

usage() { sed -n '6,10p' "$0" >&2; exit 2; }
if [ "${1:-}" = "--root" ]; then ROOT="$2"; shift 2; fi
[ $# -eq 3 ] || usage
type="$1"; contrib="$2"; name="$3"

case "$type" in
    hooks|skills|configs|subagents|architecture) ;;
    *) echo "Type inconnu : '$type' (hooks|skills|configs|subagents|architecture)" >&2; exit 2 ;;
esac

snake='^[a-z0-9]+(_[a-z0-9]+)*$'
kebab='^[a-z0-9]+(-[a-z0-9]+)*$'
case "$type" in
    hooks|subagents)
        [[ "$name" =~ $snake ]] || { echo "Nom invalide : '$name' doit être snake_case ($snake)" >&2; exit 2; } ;;
    skills|configs|architecture)
        [[ "$name" =~ $kebab ]] || { echo "Nom invalide : '$name' doit être kebab-case ($kebab)" >&2; exit 2; } ;;
esac

dir="$ROOT/$type/$contrib/$name"
[ -e "$dir" ] && { echo "Existe déjà : $type/$contrib/$name — abandon (aucun écrasement)." >&2; exit 1; }
mkdir -p "$dir"

# --- META.md (statut draft en dur) ---
cat > "$dir/META.md" <<EOF
# Meta — $name

## Source
- Auteur : $contrib
- Statut : **draft**
<!-- Champs optionnels reconnus par build-index/find : -->
<!-- - Tags : sécurité, git -->
<!-- - Dépendances : jq -->
<!-- - Testé le : AAAA-MM-JJ -->

## Contexte d'usage
<!-- Ce que fait la ressource concrètement, dans quel workflow elle s'intègre. -->

## Installation
<!-- Hook : bloc settings.json. Skill/config : chemin de copie. -->

## Environnement testé
- Outil : Claude Code
EOF

# --- Stub spécifique au type ---
case "$type" in
    hooks)
        stub="$dir/$name.sh"
        cat > "$stub" <<EOF
#!/bin/bash
# $name — décris l'événement et le comportement ici.
# Événement : PreToolUse|PostToolUse|... — matcher: "..."
# Déterministe, aucune dépendance réseau.

exit 0
EOF
        chmod +x "$stub" ;;
    skills)
        cat > "$dir/SKILL.md" <<EOF
---
name: $name
description: <!-- Une phrase : quand ce skill se déclenche et ce qu'il fait. -->
---

# $name

<!-- Instructions du skill. -->
EOF
        ;;
    subagents)
        cat > "$dir/$name.md" <<EOF
---
name: $name
description: <!-- Quand déléguer à ce subagent. -->
tools: Read, Grep, Glob
---

<!-- Prompt système du subagent. -->
EOF
        ;;
    architecture)
        cat > "$dir/$name.md" <<EOF
# $name

<!-- Décris l'architecture : ressources combinées, ordre d'exécution, décisions. -->
EOF
        ;;
    configs)
        cat > "$dir/settings.json" <<'EOF'
{
}
EOF
        ;;
esac

echo "Ressource créée : $type/$contrib/$name (statut draft)"
find "$dir" -type f | sed "s|^$ROOT/|  |" | sort
cat >&2 <<EOF

Rappel : statut = draft. Teste en conditions réelles avant beta/stable.
Pas de commit avant validation humaine.
Ensuite : bash scripts/validate.sh "$type/$contrib/$name" && bash scripts/build-index.sh
EOF
