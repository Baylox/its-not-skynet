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
            [ -f "$abs/SKILL.md" ] || violation "$res" "SKILL.md manquant" ;;
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
