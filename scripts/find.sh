#!/bin/bash
# scripts/find.sh — recherche/filtre les ressources du catalogue. Shell pur, zéro réseau.
#
# Usage : find.sh [-k mot-clé] [-t type] [-s statut] [-c contributeur] [--json] [--root <dir>]
#   -k  sous-chaîne (insensible à la casse) cherchée dans le nom + le contexte
#   -t  hooks|skills|configs|subagents|architecture
#   -s  stable|beta|draft
#   -c  contributeur (exact, ex: Baylox, anthropics)
#   --json  émet les entrées index.json correspondantes au lieu d'un tableau
#   --root  racine du repo à interroger (défaut : repo courant)
#   (sans filtre) liste tout
#
# Chemin rapide : index.json + jq. Repli : scan filesystem via lib/meta.sh.
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/lib/meta.sh"
ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$DIR/.." && pwd))"

KW=""; TYPE=""; STATUS=""; CONTRIB=""; JSON=0
while [ $# -gt 0 ]; do
    case "$1" in
        -k) KW="$2"; shift ;;
        -t) TYPE="$2"; shift ;;
        -s) STATUS="$2"; shift ;;
        -c) CONTRIB="$2"; shift ;;
        --json) JSON=1 ;;
        --root) ROOT="$2"; shift ;;
        -h|--help) sed -n '4,11p' "$0"; exit 0 ;;
        *) echo "Argument inconnu : $1" >&2; exit 2 ;;
    esac
    shift
done

INDEX="$ROOT/index.json"
kw_lc="$(printf '%s' "$KW" | tr 'A-Z' 'a-z')"

# Aligne un flux TSV en colonnes (remplace `column -t`, absent ici).
align_tsv() {
    awk -F'\t' '
        {for (i=1;i<=NF;i++){d[NR,i]=$i; if(length($i)>w[i])w[i]=length($i)} if(NF>nc)nc=NF; n=NR}
        END{for(r=1;r<=n;r++){line="";for(i=1;i<=nc;i++){
            s=d[r,i]; pad=w[i]-length(s); sp="";while(pad-->0)sp=sp" ";
            line=line s (i<nc?sp"  ":"")} print line}}'
}

# --- Chemin rapide : index.json + jq ---
if [ -f "$INDEX" ] && command -v jq >/dev/null 2>&1; then
    # avertit si l'index est plus vieux que le plus récent META.md. Parcourt
    # META_TYPES plutôt qu'un glob brace codé en dur (pas d'angle mort si un type s'ajoute).
    stale=0
    for t in $META_TYPES; do
        [ -d "$ROOT/$t" ] || continue
        [ -n "$(find "$ROOT/$t" -name META.md -newer "$INDEX" -print -quit 2>/dev/null)" ] && { stale=1; break; }
    done
    if [ "$stale" -eq 1 ]; then
        echo "Note : index.json semble périmé — lance scripts/build-index.sh." >&2
    fi
    filter='.[] | select(
        ($t=="" or .type==$t) and ($s=="" or .status==$s) and ($c=="" or .contributor==$c)
        and ($k=="" or ((.name + " " + .context) | ascii_downcase | contains($k))))'
    if [ "$JSON" -eq 1 ]; then
        jq -c --arg t "$TYPE" --arg s "$STATUS" --arg c "$CONTRIB" --arg k "$kw_lc" "$filter" "$INDEX"
    else
        { printf 'TYPE\tCONTRIB\tNOM\tSTATUT\tCONTEXTE\n'
          jq -r --arg t "$TYPE" --arg s "$STATUS" --arg c "$CONTRIB" --arg k "$kw_lc" \
              "$filter | [.type,.contributor,.name,.status,.context] | @tsv" "$INDEX"
        } | align_tsv
    fi
    exit 0
fi

# --- Repli : scan filesystem (sans index / sans jq) ---
[ "$JSON" -eq 1 ] && { echo "--json nécessite index.json + jq." >&2; exit 2; }
{
    printf 'TYPE\tCONTRIB\tNOM\tSTATUT\tCONTEXTE\n'
    while IFS= read -r res; do
        meta="$ROOT/$res/META.md"; [ -f "$meta" ] || continue
        type="${res%%/*}"; contrib="${res#*/}"; contrib="${contrib%%/*}"; name="${res##*/}"
        [ -z "$TYPE" ] || [ "$TYPE" = "$type" ] || continue
        [ -z "$CONTRIB" ] || [ "$CONTRIB" = "$contrib" ] || continue
        st="$(meta_status "$meta")"; [ -n "$st" ] || st="—"
        [ -z "$STATUS" ] || [ "$STATUS" = "$st" ] || continue
        ctx="$(meta_context_oneline "$meta")"; [ -n "$ctx" ] || ctx="—"
        if [ -n "$kw_lc" ]; then
            hay="$(printf '%s %s' "$name" "$ctx" | tr 'A-Z' 'a-z')"
            case "$hay" in *"$kw_lc"*) ;; *) continue ;; esac
        fi
        printf '%s\t%s\t%s\t%s\t%s\n' "$type" "$contrib" "$name" "$st" "$ctx"
    done < <(meta_list_resources "$ROOT")
} | align_tsv
