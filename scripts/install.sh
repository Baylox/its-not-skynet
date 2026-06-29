#!/bin/bash
# scripts/install.sh — copie une ressource du catalogue dans un projet cible.
# Shell pur, zéro réseau. Remplace le copier-coller manuel (et l'ancienne
# instruction dépréciée « .claude/skills/nom.md » mono-fichier).
#
# Usage : install.sh [--force] [--dry-run] [--root <repo>] <ressource> [projet]
#   <ressource>  chemin catalogue : <type>/<contributeur>/<nom>
#                (ex : skills/404notfood/seo-laravel)
#   [projet]     racine du projet cible (défaut : répertoire courant)
#   --force      écrase une destination existante (sinon : abandon)
#   --dry-run    affiche ce qui serait fait, sans rien copier
#   --root       racine du repo catalogue (défaut : repo de ce script)
#
# Destinations par type :
#   skills     -> <projet>/.claude/skills/<nom>/     (SKILL.md + references/, sans META.md)
#   subagents  -> <projet>/.claude/agents/<nom>.md
#   hooks      -> <projet>/.claude/hooks/<nom>/      (scripts) + rappel settings.json
#   configs    -> guidance (fusion settings.json non automatisée, trop risquée)
# Exit 0 = installé (ou dry-run OK), 1 = erreur, 2 = usage.
set -u

DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$DIR/.." && pwd))"
FORCE=0
DRY=0
declare -a POS=()
while [ $# -gt 0 ]; do
    case "$1" in
        --force)   FORCE=1 ;;
        --dry-run) DRY=1 ;;
        --root)    ROOT="$2"; shift ;;
        -h|--help) sed -n '6,18p' "$0"; exit 0 ;;
        -*) echo "Option inconnue : $1" >&2; exit 2 ;;
        *)  POS+=("$1") ;;
    esac
    shift
done
ROOT="${ROOT%/}"   # tolère un --root avec slash final (sinon le strip de préfixe échoue)

[ "${#POS[@]}" -ge 1 ] || { sed -n '6,14p' "$0" >&2; exit 2; }
# distingue « argument omis » (défaut = cwd) de « argument vide » (erreur appelant)
if [ "${#POS[@]}" -ge 2 ] && [ -z "${POS[1]}" ]; then
    echo "Projet cible vide — passe un chemin, ou omets l'argument pour le répertoire courant." >&2; exit 2
fi
res="${POS[0]#"$ROOT"/}"; res="${res%/}"        # tolère un chemin absolu ou un / final
target="${POS[1]:-.}"

# Découpe <type>/<contrib>/<nom> et valide la forme.
IFS='/' read -r type contrib name extra <<<"$res"
if [ -z "${name:-}" ] || [ -n "${extra:-}" ]; then
    echo "Ressource invalide : '$res' (attendu <type>/<contributeur>/<nom>)" >&2; exit 2
fi
# rejette les segments '.'/'..' : sinon skills/bob/. ferait un rm -rf/cp sur un parent
case "$contrib" in .|..) echo "Contributeur invalide : '$contrib'" >&2; exit 2 ;; esac
case "$name"    in .|..) echo "Nom de ressource invalide : '$name'" >&2; exit 2 ;; esac
src="$ROOT/$res"
[ -d "$src" ] || { echo "Ressource introuvable : $res" >&2; exit 1; }

dim=''; grn=''; ylw=''; rst=''
if [ -t 1 ]; then dim=$'\033[2m'; grn=$'\033[32m'; ylw=$'\033[33m'; rst=$'\033[0m'; fi
note() { printf '%s  %s%s\n' "$dim" "$1" "$rst"; }
done_msg() { printf '%s✓%s %s\n' "$grn" "$rst" "$1"; }

# Affiche le bloc ## Installation (ou ## Configuration) du META — guidance pour
# les types non automatisés (hooks, configs). Vide si aucune des deux sections.
show_meta_install() {
    awk '/^##[[:space:]]+(Installation|Configuration)/{g=1;next} g&&/^##/{exit} g{print}' \
        "$src/META.md" 2>/dev/null
}

# Copie un arbre source -> dest en refusant l'écrasement hors --force. Respecte --dry-run.
copy_into() { # src_dir dest_dir
    local s="$1" d="$2"
    if [ -e "$d" ] && [ "$FORCE" -eq 0 ]; then
        echo "Existe déjà : $d — relance avec --force pour écraser." >&2; return 1
    fi
    if [ "$DRY" -eq 1 ]; then note "[dry-run] cp -R $s -> $d"; return 0; fi
    mkdir -p "$(dirname "$d")" && rm -rf "$d" && cp -R "$s" "$d"
}

case "$type" in
    skills)
        dest="$target/.claude/skills/$name"
        if [ -e "$dest" ] && [ "$FORCE" -eq 0 ]; then
            echo "Existe déjà : $dest — relance avec --force pour écraser." >&2; exit 1
        fi
        if [ "$DRY" -eq 1 ]; then
            note "[dry-run] créerait $dest/ (SKILL.md + references/, sans META.md)"
            find "$src" -mindepth 1 -maxdepth 1 ! -name META.md \
                | while IFS= read -r f; do printf '  + %s\n' "${f#"$src"/}"; done
            exit 0
        fi
        # copie fiable : cp -R d'un coup (find -exec cp renvoie 0 même si cp échoue),
        # puis on retire le META.md (métadonnée du catalogue, hors projet cible).
        mkdir -p "$dest" && rm -rf "$dest" && mkdir -p "$dest" \
            || { echo "Préparation de $dest échouée." >&2; exit 1; }
        cp -R "$src/." "$dest/" \
            || { echo "Copie du skill échouée vers $dest" >&2; rm -rf "$dest"; exit 1; }
        rm -f "$dest/META.md"
        done_msg "Skill installé : $dest"
        note "Vérifie qu'il se charge : relance Claude Code dans $target, puis /skills."
        ;;
    subagents)
        file="$src/$name.md"
        [ -f "$file" ] || { echo "Définition introuvable : $file" >&2; exit 1; }
        dest="$target/.claude/agents/$name.md"
        if [ -e "$dest" ] && [ "$FORCE" -eq 0 ]; then
            echo "Existe déjà : $dest — relance avec --force pour écraser." >&2; exit 1
        fi
        if [ "$DRY" -eq 1 ]; then note "[dry-run] cp $file -> $dest"; exit 0; fi
        mkdir -p "$(dirname "$dest")" && cp "$file" "$dest"
        done_msg "Subagent installé : $dest"
        ;;
    hooks)
        dest="$target/.claude/hooks/$name"
        copy_into "$src" "$dest" || exit 1
        [ "$DRY" -eq 1 ] && exit 0
        # retire le META.md copié : il n'a pas sa place dans le projet cible
        rm -f "$dest/META.md"
        done_msg "Script(s) du hook copié(s) dans : $dest"
        printf '%s⚠%s  Un hook doit être câblé dans settings.json pour s'\''activer.\n' "$ylw" "$rst"
        note "Bloc d'installation indiqué par le META :"
        show_meta_install | sed 's/^/    /'
        ;;
    configs)
        printf '%s⚠%s  Une config se fusionne à la main dans settings.json (pas d'\''écrasement auto).\n' "$ylw" "$rst"
        note "Fichier(s) source :"
        find "$src" -mindepth 1 -maxdepth 1 -type f ! -name META.md | sed 's|^|    |'
        note "Cible et détails indiqués par le META :"
        show_meta_install | sed 's/^/    /'
        ;;
    architecture)
        echo "Le type 'architecture' est documentaire — rien à installer." >&2; exit 1
        ;;
    *)
        echo "Type non installable : '$type'" >&2; exit 2
        ;;
esac
