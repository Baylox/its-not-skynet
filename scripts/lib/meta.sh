#!/bin/bash
# scripts/lib/meta.sh — fonctions partagées de parsing META.md (shell pur, zéro réseau).
# Sourcé par validate.sh, build-index.sh, find.sh. Aucune dépendance hors coreutils.
#
# Conventions du repo : chaque ressource vit dans <type>/<contributeur>/<nom>/
# avec un META.md. Les 5 types : hooks skills configs subagents architecture.

# Les 5 types de ressources, dans l'ordre d'affichage.
META_TYPES="hooks skills configs subagents architecture"

# Liste les répertoires-ressource <type>/<contributeur>/<nom>.
# $1 = racine repo. Émet un chemin relatif par ligne, trié (ordre déterministe).
meta_list_resources() {
    local root="$1" type
    for type in $META_TYPES; do
        [ -d "$root/$type" ] || continue
        # profondeur exacte 2 sous le type : ignore les README de niveau type/ et type/contrib/
        find "$root/$type" -mindepth 2 -maxdepth 2 -type d 2>/dev/null \
            | sed "s|^$root/||"
    done | sort
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

# Première ligne non vide de la section "## Contexte d'usage" (pour le catalogue).
# awk : depuis "## Contexte" jusqu'au prochain "##" -> 1re ligne de texte, espaces collés.
meta_context_oneline() {
    awk '
        /^##[[:space:]]+Contexte/ {grab=1; next}
        grab && /^##/ {exit}
        grab && NF {print; exit}
    ' "$1" 2>/dev/null | sed -E 's/[[:space:]]+/ /g; s/^ //; s/ $//'
}
