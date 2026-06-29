#!/bin/bash
# scripts/validate.sh — lint des ressources its-not-skynet. Shell pur, zéro réseau.
# Le gardien de la règle fondamentale : chaque ressource conforme aux conventions.
#
# Usage : validate.sh [--quiet] [--root <dir>] [path ...]
#   (sans args)   valide toutes les ressources sous la racine du repo
#   path ...      valide seulement les dossiers donnés (CI : fichiers changés)
#   --quiet       n'affiche que les problèmes, supprime le résumé OK
#
# Exit 0 = conforme, 1 = violations. Les warnings n'affectent pas le code de sortie.
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/lib/meta.sh"

ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$DIR/.." && pwd))"
QUIET=0
declare -a TARGETS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --quiet) QUIET=1 ;;
        --root)  ROOT="$2"; shift ;;
        --) shift; while [ $# -gt 0 ]; do TARGETS+=("$1"); shift; done; break ;;
        -*) echo "Option inconnue : $1" >&2; exit 2 ;;
        *)  TARGETS+=("$1") ;;
    esac
    shift
done

snake='^[a-z0-9]+(_[a-z0-9]+)*$'
kebab='^[a-z0-9]+(-[a-z0-9]+)*$'
valid_status='^(stable|beta|draft)$'

fail=0
warned=0
violation() { printf 'KO    %-50s %s\n' "$1" "$2" >&2; fail=1; }
warning()   { printf 'WARN  %-50s %s\n' "$1" "$2" >&2; warned=1; }

# Seuil de lignes d'un SKILL.md au-delà duquel on conseille la progressive
# disclosure (externaliser le détail vers references/). Warning, non bloquant.
SKILL_MAX_LINES=500

# Lint spécifique aux skills : présence et contenu du frontmatter, cohérence
# name/dossier, description remplie, liens locaux valides, budget de lignes.
check_skill() {
    local abs="$1" res="$2" name="$3"
    local skill="$abs/SKILL.md"   # local séparé : "$abs" n'est pas encore affecté dans le local précédent

    [ -f "$skill" ] || { violation "$res" "SKILL.md manquant"; return; }

    # frontmatter YAML obligatoire (Claude Code le requiert pour charger le skill)
    if ! meta_has_frontmatter "$skill"; then
        violation "$res" "SKILL.md sans frontmatter YAML (--- attendu en 1re ligne)"
        return
    fi

    # name : présent et aligné sur le dossier (clé de déclenchement du skill)
    local fname; fname="$(meta_frontmatter "$skill" name)"
    if [ -z "$fname" ]; then
        violation "$res" "frontmatter SKILL.md : champ 'name' manquant"
    elif [ "$fname" != "$name" ]; then
        violation "$res" "frontmatter name ('$fname') ≠ nom du dossier ('$name')"
    fi

    # description : présente et réellement remplie (pas le placeholder du stub)
    local fdesc; fdesc="$(meta_frontmatter "$skill" description)"
    if [ -z "$fdesc" ]; then
        violation "$res" "frontmatter SKILL.md : champ 'description' manquant"
    elif case "$fdesc" in *'<!--'*) true ;; *) false ;; esac; then
        violation "$res" "description SKILL.md non remplie (placeholder du stub)"
    fi

    # liens markdown locaux cassés (ex: references/foo.md absent) — non bloquant
    local link target
    while IFS= read -r link; do
        [ -n "$link" ] || continue
        case "$link" in http://*|https://*|'#'*|mailto:*) continue ;; esac
        target="${link%%#*}"
        target="${target%% *}"   # retire un titre optionnel : [x](path "Titre")
        [ -n "$target" ] || continue
        [ -e "$abs/$target" ] || warning "$res" "lien cassé dans SKILL.md : $target"
    done < <(grep -oE '\]\([^)]+\)' "$skill" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//')

    # budget de lignes : au-delà du seuil, recommander la progressive disclosure
    local lines; lines="$(awk 'END{print NR}' "$skill")"
    [ "${lines:-0}" -le "$SKILL_MAX_LINES" ] \
        || warning "$res" "SKILL.md = ${lines} lignes (> ${SKILL_MAX_LINES} : externalise le détail vers references/)"

    # fichiers references/ jamais cités par le SKILL.md (orphelins) — non bloquant.
    # Match par nom de fichier : couvre les liens markdown ET les chemins en
    # backticks (ex: `references/java.md`). Évite les faux positifs de syntaxe.
    if [ -d "$abs/references" ]; then
        local ref base esc
        while IFS= read -r ref; do
            base="$(basename "$ref")"
            # frontière de nom (et non sous-chaîne) : un orphelin a.md ne doit pas
            # être masqué par la citation d'un ba.md. '/' compte comme frontière.
            esc="$(printf '%s' "$base" | sed 's/[][\\.*^$/]/\\&/g')"
            grep -qE "(^|[^[:alnum:]_-])${esc}([^[:alnum:]_-]|$)" "$skill" 2>/dev/null \
                || warning "$res" "référence orpheline (jamais citée dans SKILL.md) : references/$base"
        done < <(find "$abs/references" -type f 2>/dev/null)
    fi
}

check_one() {
    local res="$1" abs="$ROOT/$1"
    local type="${res%%/*}" name="${res##*/}"
    local meta="$abs/META.md"

    [ -f "$meta" ] || { violation "$res" "META.md manquant"; return; }

    # 1) nommage selon le type
    case "$type" in
        hooks|subagents)
            [[ "$name" =~ $snake ]] || violation "$res" "dossier doit être snake_case" ;;
        skills|configs|architecture)
            [[ "$name" =~ $kebab ]] || violation "$res" "dossier doit être kebab-case" ;;
    esac

    # 2) sections universelles
    meta_has_section "$meta" "Source"       || violation "$res" "section ## Source manquante"
    meta_has_section "$meta" "Contexte"     || violation "$res" "section ## Contexte d'usage manquante"
    meta_has_section "$meta" "Environnement" || violation "$res" "section ## Environnement testé manquante"

    # 3) champ Auteur
    [ -n "$(meta_field "$meta" Auteur)" ] || violation "$res" "champ Auteur vide ou absent"

    # 4) statut présent et valide
    local st; st="$(meta_status "$meta")"
    if [ -z "$st" ]; then
        violation "$res" "Statut manquant (stable|beta|draft requis)"
    elif ! [[ "$st" =~ $valid_status ]]; then
        violation "$res" "Statut invalide : '$st'"
    fi

    # 5) section d'installation (recommandée, non bloquante)
    meta_has_section "$meta" "(Installation|Configuration)" \
        || warning "$res" "ni ## Installation ni ## Configuration"

    # 6) fichier requis par type
    case "$type" in
        hooks)
            ls "$abs"/*.sh >/dev/null 2>&1 || [ -f "$abs/hook.json" ] \
                || violation "$res" "aucun *.sh ni hook.json" ;;
        skills)
            check_skill "$abs" "$res" "$name" ;;
        subagents|architecture)
            [ -n "$(find "$abs" -maxdepth 1 -name '*.md' ! -name META.md -print -quit)" ] \
                || violation "$res" "aucun fichier .md de définition" ;;
        configs)
            [ -n "$(find "$abs" -maxdepth 1 -type f ! -name META.md -print -quit)" ] \
                || violation "$res" "aucun fichier de config" ;;
    esac
}

# Normalise un chemin (fichier ou dossier) en dossier ressource type/contrib/nom.
to_resource() {
    local p="${1#"$ROOT"/}"
    case "$p" in
        hooks/*|skills/*|configs/*|subagents/*|architecture/*)
            echo "$p" | cut -d/ -f1-3 ;;
    esac
}

count=0
if [ "${#TARGETS[@]}" -gt 0 ]; then
    while IFS= read -r res; do
        [ -n "$res" ] || continue
        [ -d "$ROOT/$res" ] || continue
        check_one "$res"; count=$((count + 1))
    done < <(for p in "${TARGETS[@]}"; do to_resource "$p"; done | sort -u)
else
    while IFS= read -r res; do
        check_one "$res"; count=$((count + 1))
    done < <(meta_list_resources "$ROOT")
fi

if [ "$fail" -eq 0 ] && [ "$QUIET" -eq 0 ]; then
    msg="OK — $count ressource(s) conforme(s)."
    [ "$warned" -eq 1 ] && msg="$msg (avec warnings)"
    echo "$msg"
fi
exit "$fail"
