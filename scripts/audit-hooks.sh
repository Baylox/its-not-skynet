#!/bin/bash
# scripts/audit-hooks.sh — audit de sécurité des scripts shell des ressources.
# Shell pur, zéro réseau, déterministe. Garde-fou de la règle fondamentale :
# « rien qui nécessite un réseau non maîtrisé à l'exécution ».
#
# Ce scan est CONSULTATIF : il fait remonter des lignes à risque pour qu'un
# humain tranche (cohérent avec « validé par son auteur »). Il ne remplace pas
# une revue. Les lignes de commentaire (#...) sont ignorées.
#
# Usage : audit-hooks.sh [--strict] [--quiet] [--root <dir>] [path ...]
#   (sans args)   audite tous les *.sh sous hooks/ et subagents/
#   path ...      audite seulement les dossiers/fichiers donnés (CI : diff)
#   --strict      exit 1 si au moins une alerte HIGH (défaut : exit 0, info)
#   --quiet       n'affiche que les alertes, supprime le résumé OK
#
# Suppression ciblée : ajouter « # audit:allow » en fin de ligne neutralise
# l'alerte sur CETTE ligne (ex : un hook de sécurité qui grep volontairement
# un motif dangereux). À utiliser sciemment — c'est une déclaration d'intention.
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/lib/meta.sh"

ROOT="$(meta_default_root "$DIR")"
STRICT=0; QUIET=0
declare -a TARGETS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --strict) STRICT=1 ;;
        --quiet)  QUIET=1 ;;
        --root)   ROOT="$2"; shift ;;
        --) shift; while [ $# -gt 0 ]; do TARGETS+=("$1"); shift; done; break ;;
        -*) echo "Option inconnue : $1" >&2; exit 2 ;;
        *)  TARGETS+=("$1") ;;
    esac
    shift
done

# --- Règles : niveau @@ motif ERE @@ libellé --------------------------------
# HIGH  : exécution distante / réseau non maîtrisé / destruction directe.
# WARN  : surface à risque, souvent légitime mais à justifier.
# Le motif est testé sur le code (commentaires retirés). Ordre = priorité.
# Séparateur de champ : @@ (absent des regex, qui utilisent | pour l'alternation).
declare -a RULES=(
    "HIGH@@(curl|wget|fetch)[^|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba)?sh@@exécution distante (téléchargement piping vers shell)"
    "HIGH@@\b(curl|wget)\b@@appel réseau sortant (curl/wget) à l'exécution"
    "HIGH@@\b(nc|ncat|netcat|telnet|socat)\b@@outil réseau brut"
    "HIGH@@/dev/(tcp|udp)/@@socket réseau via /dev/tcp"
    "HIGH@@\b(ssh|scp|sftp|rsync)\b@@transfert/exécution distante"
    "HIGH@@\brm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f@@suppression récursive forcée (rm -rf)"
    "WARN@@\beval\b@@eval — exécution de chaîne dynamique"
    "WARN@@\bsudo\b@@élévation de privilèges (sudo)"
    "WARN@@\bchmod[[:space:]]+[0-7]*777@@permissions trop ouvertes (chmod 777)"
)

high=0; warn=0
alert() { # niveau, fichier:ligne, libellé, extrait
    printf '%-5s %-46s %s\n' "$1" "$2" "$3" >&2
    [ "$1" = "HIGH" ] && high=$((high+1)) || warn=$((warn+1))
}

# Audite un seul fichier *.sh ligne par ligne.
audit_file() {
    local f="$1" rel="${1#"$ROOT"/}" ln=0
    while IFS= read -r line || [ -n "$line" ]; do
        ln=$((ln+1))
        # ignore les lignes vides et les commentaires purs
        case "$line" in ''|\#*) continue ;; esac
        # suppression explicite par l'auteur
        case "$line" in *'# audit:allow'*) continue ;; esac
        # Test sur la ligne ENTIÈRE : couper au premier '#' masquerait un motif
        # après un '#' en chaîne/URL (ex: curl "http://x#f" | sh -> non détecté).
        # Les commentaires purs et « # audit:allow » sont déjà court-circuités ci-dessus ;
        # un mot-clé à risque dans un commentaire de fin de ligne alertera (à neutraliser
        # sciemment via « # audit:allow »), faux positif acceptable pour un garde-fou.
        local rule level rest pat label
        for rule in "${RULES[@]}"; do
            level="${rule%%@@*}"; rest="${rule#*@@}"
            pat="${rest%%@@*}"; label="${rest#*@@}"
            if printf '%s' "$line" | grep -qE "$pat"; then
                local snip; snip="$(printf '%s' "$line" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' | cut -c1-60)"
                alert "$level" "$rel:$ln" "$label  | $snip"
                break  # une alerte par ligne (la plus prioritaire)
            fi
        done
    done < "$f"
}

# --- Collecte des fichiers à auditer ----------------------------------------
declare -a FILES=()
collect_under() { # ajoute les *.sh sous un chemin (fichier ou dossier)
    local p="$1"
    if [ -f "$p" ]; then
        case "$p" in *.sh) FILES+=("$p") ;; esac
    elif [ -d "$p" ]; then
        while IFS= read -r f; do FILES+=("$f"); done \
            < <(find "$p" -type f -name '*.sh' 2>/dev/null | LC_ALL=C sort)
    fi
}

if [ "${#TARGETS[@]}" -gt 0 ]; then
    for p in "${TARGETS[@]}"; do
        case "$p" in /*) collect_under "$p" ;; *) collect_under "$ROOT/$p" ;; esac
    done
else
    for t in hooks subagents; do collect_under "$ROOT/$t"; done
fi

# dédoublonne en préservant l'ordre trié (gardé : sans fichier, on ne passe pas
# une chaîne vide à sort — plus de contournement grep -v '^$')
declare -a UNIQ=()
last=""
if [ "${#FILES[@]}" -gt 0 ]; then
    while IFS= read -r f; do [ "$f" = "$last" ] && continue; UNIQ+=("$f"); last="$f"; done \
        < <(printf '%s\n' "${FILES[@]}" | LC_ALL=C sort -u)
fi

for f in "${UNIQ[@]:-}"; do [ -n "$f" ] && audit_file "$f"; done

n="${#UNIQ[@]}"
if [ "$QUIET" -eq 0 ]; then
    if [ "$high" -eq 0 ] && [ "$warn" -eq 0 ]; then
        echo "OK — $n script(s) audité(s), aucune alerte."
    else
        echo "Audit : $n script(s) — $high HIGH, $warn WARN. (revue humaine requise)" >&2
    fi
fi

# Exit : par défaut consultatif (0). --strict échoue sur au moins un HIGH.
if [ "$STRICT" -eq 1 ] && [ "$high" -gt 0 ]; then exit 1; fi
exit 0
