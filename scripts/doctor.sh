#!/bin/bash
# scripts/doctor.sh — bilan de santé avant PR. Shell pur, zéro réseau.
# Le copilote du contributeur : enchaîne les contrôles du repo et explique
# quoi faire ensuite. Pont entre new.sh (création) et la CI (vérification).
#
# Usage : doctor.sh [--fix] [--root <dir>] [path ...]
#   (sans args)   contrôle tout le repo
#   path ...      cible une/des ressource(s) (ex : la tienne avant PR)
#   --fix         régénère le catalogue si désynchronisé (au lieu d'échouer)
#
# Étapes : 1) lint des ressources  2) catalogue à jour  3) audit sécurité.
# Exit 0 = prêt pour la PR. Exit 1 = au moins un contrôle bloquant a échoué.
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$DIR/.." && pwd))"
FIX=0
declare -a TARGETS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --fix)  FIX=1 ;;
        --root) ROOT="$2"; shift ;;
        --) shift; while [ $# -gt 0 ]; do TARGETS+=("$1"); shift; done; break ;;
        -*) echo "Option inconnue : $1" >&2; exit 2 ;;
        *)  TARGETS+=("$1") ;;
    esac
    shift
done

bold=''; dim=''; red=''; grn=''; ylw=''; rst=''
if [ -t 1 ]; then
    bold=$'\033[1m'; dim=$'\033[2m'; red=$'\033[31m'; grn=$'\033[32m'; ylw=$'\033[33m'; rst=$'\033[0m'
fi

rc=0
step() { printf '\n%s== %s ==%s\n' "$bold" "$1" "$rst"; }
ok()   { printf '%s✓%s %s\n' "$grn" "$rst" "$1"; }
ko()   { printf '%s✗%s %s\n' "$red" "$rst" "$1"; rc=1; }
note() { printf '%s  %s%s\n' "$dim" "$1" "$rst"; }

# --- 1) Lint des ressources --------------------------------------------------
step "1/3 Lint des ressources (validate.sh)"
if bash "$DIR/validate.sh" --root "$ROOT" --quiet "${TARGETS[@]+"${TARGETS[@]}"}"; then
    ok "Conventions respectées (META, sections, statut, nommage)."
else
    ko "Des ressources ne respectent pas les conventions (voir ci-dessus)."
    note "Corrige le META.md ou la structure, puis relance : bash scripts/doctor.sh"
fi

# --- 2) Catalogue à jour -----------------------------------------------------
step "2/3 Catalogue (build-index.sh)"
if bash "$DIR/build-index.sh" --root "$ROOT" --check >/dev/null 2>&1; then
    ok "CATALOG.md et index.json sont synchronisés."
elif [ "$FIX" -eq 1 ]; then
    if bash "$DIR/build-index.sh" --root "$ROOT" >/dev/null 2>&1; then
        ok "Catalogue régénéré (--fix). Pense à committer CATALOG.md / index.json."
    else
        ko "Échec de la régénération du catalogue."
    fi
else
    ko "Catalogue désynchronisé."
    note "Lance : bash scripts/build-index.sh   (ou doctor.sh --fix)"
fi

# --- 3) Audit sécurité (consultatif) ----------------------------------------
step "3/3 Audit sécurité des hooks (audit-hooks.sh)"
audit_out="$(bash "$DIR/audit-hooks.sh" --root "$ROOT" --quiet "${TARGETS[@]+"${TARGETS[@]}"}" 2>&1)"
if [ -z "$audit_out" ]; then
    ok "Aucune alerte de sécurité."
else
    printf '%s\n' "$audit_out"
    printf '%s⚠%s  Alertes de sécurité — à confirmer par revue humaine.\n' "$ylw" "$rst"
    note "Faux positif légitime ? Ajoute « # audit:allow » en fin de ligne."
    note "(consultatif : ne bloque pas le doctor)"
fi

# --- Verdict -----------------------------------------------------------------
printf '\n%s' "$bold"
if [ "$rc" -eq 0 ]; then
    printf '%s✓ Prêt pour la PR.%s\n' "$grn" "$rst"
    note "Rappel : statut ≥ beta pour une PR, et teste en conditions réelles."
else
    printf '%s✗ Pas encore prêt — corrige les points ✗ ci-dessus.%s\n' "$red" "$rst"
fi
exit "$rc"
