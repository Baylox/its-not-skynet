#!/bin/bash
# scripts/build-index.sh — génère le catalogue machine depuis le filesystem + META.md.
# Shell pur, zéro réseau. Sortie déterministe (fonction pure de l'arbre, tri stable).
#
# Usage : build-index.sh [--root <dir>] [--check] [--no-json] [--no-readme]
#   (défaut)     (re)génère CATALOG.md + index.json à la racine du repo
#   --check      génère en temp, compare aux fichiers commités, exit 1 si désynchro (CI)
#   --no-json    saute index.json (environnements sans jq)
#   --no-readme  saute la resync des blocs auto dans les README
#
# index.json nécessite jq (déjà dépendance du repo) ; auto-skip propre si absent.
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/lib/meta.sh"

ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$DIR/.." && pwd))"
CHECK=0; DO_JSON=1; DO_README=1
while [ $# -gt 0 ]; do
    case "$1" in
        --root) ROOT="$2"; shift ;;
        --check) CHECK=1 ;;
        --no-json) DO_JSON=0 ;;
        --no-readme) DO_README=0 ;;
        *) echo "Option inconnue : $1" >&2; exit 2 ;;
    esac
    shift
done

command -v jq >/dev/null 2>&1 || DO_JSON=0

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# --- Collecte TSV : type \t contrib \t nom \t path \t statut \t contexte ---
tsv="$TMP/data.tsv"
: > "$tsv"
while IFS= read -r res; do
    meta="$ROOT/$res/META.md"
    [ -f "$meta" ] || continue
    type="${res%%/*}"
    contrib="${res#*/}"; contrib="${contrib%%/*}"
    name="${res##*/}"
    status="$(meta_status "$meta")"; [ -n "$status" ] || status="—"
    context="$(meta_context_oneline "$meta")"; [ -n "$context" ] || context="—"
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$type" "$contrib" "$name" "$res" "$status" "$context" >> "$tsv"
done < <(meta_list_resources "$ROOT")

count="$(wc -l < "$tsv" | tr -d ' ')"

# Compte les lignes du TSV dont la colonne $1 vaut $2 (déterministe, pur awk).
tsv_count() { awk -F'\t' -v c="$1" -v k="$2" '$c==k{n++} END{print n+0}' "$tsv"; }

# --- CATALOG.md ---
cat_md="$TMP/CATALOG.md"
{
    echo "# Catalogue"
    echo
    echo "_Généré par \`scripts/build-index.sh\` — ne pas éditer à la main entre les balises._"
    echo "_$count ressources._"
    echo
    echo "<!-- BEGIN AUTO -->"
    echo "| Type | Contributeur | Nom | Statut | Contexte |"
    echo "|------|--------------|-----|--------|----------|"
    while IFS=$'\t' read -r type contrib name _ status context; do
        # échappe les | pour ne pas casser le tableau markdown
        ectx="$(printf '%s' "$context" | sed 's/|/\\|/g')"
        printf '| %s | %s | %s | %s | %s |\n' "$type" "$contrib" "$name" "$status" "$ectx"
    done < "$tsv"
    echo "<!-- END AUTO -->"

    # --- Statistiques (dérivées du même TSV, ordre stable) ---
    echo
    echo "## Statistiques"
    echo
    echo "<!-- BEGIN STATS -->"
    echo "**Par type**"
    echo
    echo "| Type | Ressources |"
    echo "|------|-----------|"
    for type in $META_TYPES; do
        n="$(tsv_count 1 "$type")"
        [ "$n" -gt 0 ] && printf '| %s | %s |\n' "$type" "$n"
    done
    echo
    echo "**Par statut**"
    echo
    echo "| Statut | Ressources |"
    echo "|--------|-----------|"
    for st in stable beta draft —; do
        n="$(tsv_count 5 "$st")"
        [ "$n" -gt 0 ] && printf '| %s | %s |\n' "$st" "$n"
    done
    echo
    echo "**Par contributeur**"
    echo
    echo "| Contributeur | Ressources |"
    echo "|--------------|-----------|"
    # tri : nombre décroissant, puis contributeur alphabétique (départage stable)
    cut -f2 "$tsv" | LC_ALL=C sort | uniq -c | LC_ALL=C sort -k1,1nr -k2,2 \
        | while read -r n contrib; do printf '| %s | %s |\n' "$contrib" "$n"; done
    echo "<!-- END STATS -->"
} > "$cat_md"

# --- index.json (jq pour échappement sûr) ---
json="$TMP/index.json"
if [ "$DO_JSON" -eq 1 ]; then
    jq -R -s -c '
        split("\n") | map(select(length > 0)) | map(split("\t"))
        | map({type:.[0], contributor:.[1], name:.[2], path:.[3], status:.[4], context:.[5]})
    ' "$tsv" > "$json"
fi

# --- Resync des blocs auto dans les README (opt-in : seulement si balises présentes) ---
inject_readme() {
    local readme="$1" type="$2"
    [ -f "$readme" ] || return 0
    # Appariement strict des balises avant de réécrire en place : sinon l'awk
    # d'injection supprime tout le contenu après une balise orpheline/mal ordonnée.
    local nb ne lb le
    nb="$(grep -c '<!-- BEGIN AUTO -->' "$readme")"
    ne="$(grep -c '<!-- END AUTO -->'   "$readme")"
    [ "$nb" -eq 0 ] && [ "$ne" -eq 0 ] && return 0   # pas de bloc auto : opt-out silencieux
    if [ "$nb" -ne 1 ] || [ "$ne" -ne 1 ]; then
        echo "README $readme : balises AUTO non appariées ($nb BEGIN / $ne END) — resync ignorée." >&2
        return 0
    fi
    lb="$(grep -n '<!-- BEGIN AUTO -->' "$readme" | head -1 | cut -d: -f1)"
    le="$(grep -n '<!-- END AUTO -->'   "$readme" | head -1 | cut -d: -f1)"
    if [ "$lb" -ge "$le" ]; then
        echo "README $readme : balise END avant BEGIN — resync ignorée." >&2
        return 0
    fi
    local tbl="$TMP/tbl-$type.md"
    {
        echo "| Contributeur | Nom | Statut | Contexte |"
        echo "|--------------|-----|--------|----------|"
        while IFS=$'\t' read -r t contrib name _ status context; do
            [ "$t" = "$type" ] || continue
            ectx="$(printf '%s' "$context" | sed 's/|/\\|/g')"
            printf '| %s | %s | %s | %s |\n' "$contrib" "$name" "$status" "$ectx"
        done < "$tsv"
    } > "$tbl"
    awk -v tbl="$tbl" '
        /<!-- BEGIN AUTO -->/ {print; while ((getline l < tbl) > 0) print l; skip=1; next}
        /<!-- END AUTO -->/   {skip=0}
        !skip
    ' "$readme" > "$readme.tmp" && mv "$readme.tmp" "$readme"
}

# --- Mode --check : compare sans écrire ---
if [ "$CHECK" -eq 1 ]; then
    rc=0
    if ! diff -q "$cat_md" "$ROOT/CATALOG.md" >/dev/null 2>&1; then
        echo "CATALOG.md désynchronisé — lance scripts/build-index.sh" >&2; rc=1
    fi
    if [ "$DO_JSON" -eq 1 ] && ! diff -q "$json" "$ROOT/index.json" >/dev/null 2>&1; then
        echo "index.json désynchronisé — lance scripts/build-index.sh" >&2; rc=1
    fi
    [ "$rc" -eq 0 ] && echo "Catalogue à jour ($count ressources)."
    exit "$rc"
fi

# --- Écriture ---
mv "$cat_md" "$ROOT/CATALOG.md"
[ "$DO_JSON" -eq 1 ] && mv "$json" "$ROOT/index.json"
if [ "$DO_README" -eq 1 ]; then
    for type in $META_TYPES; do
        inject_readme "$ROOT/$type/README.md" "$type"
    done
fi

echo "Catalogue généré : CATALOG.md$([ "$DO_JSON" -eq 1 ] && echo ' + index.json') ($count ressources)."
