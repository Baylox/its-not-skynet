#!/bin/bash
# scripts/doctor.sh — bilan de santé avant PR. Shell pur, zéro réseau.
# Le copilote du contributeur : enchaîne les contrôles du repo et explique
# quoi faire ensuite. Pont entre new.sh (création) et la CI (vérification).
#
# Usage : doctor.sh [--fix] [--root <dir>] [path ...]
#         doctor.sh --new <type> <pseudo> <nom>
#   (sans args)   contrôle tout le repo
#   path ...      cible une/des ressource(s) (ex : la tienne avant PR)
#   --fix         régénère le catalogue si désynchronisé (au lieu d'échouer)
#   --new         scaffolde (new.sh) → ouvre $EDITOR si défini → lint la ressource
#
# Étapes : 1) lint des ressources  2) catalogue à jour  3) audit sécurité.
# Exit 0 = prêt pour la PR. Exit 1 = au moins un contrôle bloquant a échoué.
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/lib/meta.sh"
ROOT="$(meta_default_root "$DIR")"
FIX=0
NEW=0
ntype=''; npseudo=''; nname=''
declare -a TARGETS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --fix)  FIX=1 ;;
        --new)
            NEW=1
            ntype="${2:-}"; npseudo="${3:-}"; nname="${4:-}"
            if [ -z "$ntype" ] || [ -z "$npseudo" ] || [ -z "$nname" ]; then
                echo "Usage : doctor.sh --new <type> <pseudo> <nom>" >&2; exit 2
            fi
            shift 3 ;;
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

# --- Mode --new : scaffolde → édite → lint, puis sort ------------------------
# Boucle courte de création (pont new.sh → validate.sh). N'enchaîne PAS le
# catalogue/audit : une ressource fraîche est en draft, pas destinée au catalogue
# tant qu'elle n'est pas testée.
if [ "$NEW" -eq 1 ]; then
    step "Création (new.sh)"
    if bash "$DIR/new.sh" --root "$ROOT" "$ntype" "$npseudo" "$nname"; then
        ok "Ressource scaffoldée (statut draft)."
    else
        ko "Échec du scaffold — voir ci-dessus."; exit 1
    fi

    res="$ntype/$npseudo/$nname"
    main=''
    case "$ntype" in
        skills)                 main="$ROOT/$res/SKILL.md" ;;
        hooks)                  main="$ROOT/$res/$nname.sh" ;;
        subagents|architecture) main="$ROOT/$res/$nname.md" ;;
        configs)                main="$ROOT/$res/settings.json" ;;
    esac

    if [ -n "${EDITOR:-}" ] && [ -t 0 ] && [ -n "$main" ] && [ -f "$main" ]; then
        step "Édition (\$EDITOR)"
        "$EDITOR" "$main"
    elif [ -n "$main" ]; then
        note "Édite : $main"
        note "(définis \$EDITOR pour l'ouvrir automatiquement ici)"
    fi

    step "Lint (validate.sh)"
    if bash "$DIR/validate.sh" --root "$ROOT" "$res"; then
        ok "Ressource conforme aux conventions."
    else
        ko "À corriger (voir ci-dessus)."
    fi
    note "Ensuite : teste en conditions réelles, passe le statut à beta,"
    note "puis avant la PR : bash scripts/doctor.sh $res"
    exit "$rc"
fi

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
