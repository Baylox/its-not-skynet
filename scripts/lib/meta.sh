#!/bin/bash
# scripts/lib/meta.sh — fonctions partagées de parsing META.md (shell pur, zéro réseau).
# Sourcé par tous les scripts du tooling (validate, build-index, find, audit-hooks,
# install, new, doctor). Aucune dépendance hors coreutils, aucun effet de bord top-level.
#
# Conventions du repo : chaque ressource vit dans <type>/<contributeur>/<nom>/
# avec un META.md. Les 5 types : hooks skills configs subagents architecture.

# Les constantes META_* ci-dessous sont l'API publique de cette lib : consommées
# par les scripts qui la sourcent, donc « inutilisées » du seul point de vue d'un
# linter mono-fichier.
# shellcheck disable=SC2034

# Les 5 types de ressources, dans l'ordre d'affichage.
META_TYPES="hooks skills configs subagents architecture"

# Conventions de nommage par type + statuts valides — source unique de vérité
# (consommées par new.sh et validate.sh ; étendre un statut = éditer META_STATUSES).
META_RE_SNAKE='^[a-z0-9]+(_[a-z0-9]+)*$'
META_RE_KEBAB='^[a-z0-9]+(-[a-z0-9]+)*$'
META_STATUSES="stable beta draft"

# Racine du repo depuis le dossier d'un script ($1 = dossier du script appelant).
# git si disponible, sinon le parent (scripts/.. = racine). Centralise le bootstrap
# ROOT dupliqué dans tous les scripts.
meta_default_root() {
    git -C "$1" rev-parse --show-toplevel 2>/dev/null || (cd "$1/.." && pwd)
}

# Liste les répertoires-ressource <type>/<contributeur>/<nom>.
# $1 = racine repo. Émet un chemin relatif par ligne, trié (ordre déterministe).
meta_list_resources() {
    local root="$1" type
    for type in $META_TYPES; do
        [ -d "$root/$type" ] || continue
        # profondeur exacte 2 sous le type : ignore les README de niveau type/ et type/contrib/
        # strip du préfixe en pur-shell : $root injecté dans un sed serait
        # interprété comme regex BRE (un [ . * dans le chemin de checkout
        # ferait perdre TOUTES les ressources silencieusement).
        find "$root/$type" -mindepth 2 -maxdepth 2 -type d 2>/dev/null \
            | while IFS= read -r d; do printf '%s\n' "${d#"$root"/}"; done
    done | LC_ALL=C sort
}

# Extrait la valeur d'un champ "- Clé : valeur" (typiquement sous ## Source).
# $1 = fichier META, $2 = clé (ex: Auteur, Statut, Repo, Tags).
# Tolère le gras markdown **...**, les espaces et les accents.
meta_field() {
    local file="$1" key="$2"
    grep -m1 -E "^[[:space:]]*-[[:space:]]*${key}[[:space:]]*:" "$file" 2>/dev/null \
        | sed -E "s/^[[:space:]]*-[[:space:]]*${key}[[:space:]]*:[[:space:]]*//" \
        | sed -E 's/\*\*//g; s/[[:space:]]+$//'
}

# Le statut, normalisé en minuscules sans gras. Vide si absent.
meta_status() {
    meta_field "$1" "Statut" | tr 'A-Z' 'a-z'
}

# Vrai si une section "## <titre>" existe dans le fichier ($2 = motif de titre).
meta_has_section() {
    grep -qE "^##[[:space:]]+$2" "$1" 2>/dev/null
}

# Extrait la valeur d'un champ du frontmatter YAML (bloc entre les deux '---' en
# tête de fichier). $1 = fichier, $2 = clé (ex: name, description). Vide si absent
# ou si le fichier n'a pas de frontmatter. Gère les valeurs entre guillemets.
meta_frontmatter() {
    local file="$1" key="$2"
    awk -v key="$key" '
        NR==1 { sub(/^\357\273\277/, "") } # tolère un BOM UTF-8 en tête (octal: mawk+gawk)
        { sub(/\r$/, "") }               # tolère les fins de ligne CRLF
        NR==1 && $0!="---" {exit}        # pas de frontmatter
        NR==1 {next}                     # ouvre le bloc
        $0=="---" {exit}                 # ferme le bloc
        {
            i = index($0, ":")
            if (i == 0) next
            k = substr($0, 1, i-1)
            gsub(/^[ \t]+|[ \t]+$/, "", k)
            if (k != key) next
            v = substr($0, i+1)
            gsub(/^[ \t]+|[ \t]+$/, "", v)
            gsub(/^"|"$/, "", v)         # retire les guillemets encadrants
            print v
            exit
        }
    ' "$file" 2>/dev/null
}

# Vrai si le fichier débute par un frontmatter YAML (première ligne = ---).
# Tolère les fins de ligne CRLF.
meta_has_frontmatter() {
    [ -f "$1" ] || return 1
    local first; IFS= read -r first < "$1"
    first="${first#$'\xEF\xBB\xBF'}"   # tolère un BOM UTF-8
    [ "${first%$'\r'}" = "---" ]
}

# Première ligne non vide de la section "## Contexte d'usage" (pour le catalogue).
# awk : depuis "## Contexte" jusqu'au prochain "##" -> 1re ligne de texte, espaces collés.
meta_context_oneline() {
    awk '
        /^##[[:space:]]+Contexte/ {grab=1; next}
        grab && /^##/ {exit}
        grab && NF {print; exit}
    ' "$1" 2>/dev/null | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}
