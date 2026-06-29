# Meta — pre-pr-check

## Source
- Auteur : Baylox
- Statut : **beta**
- Tags : contribution, CI, validation, méta
- Dépendances : aucune (scripts du repo ; `jq` optionnel)

## Contexte d'usage
À lancer juste avant d'ouvrir une PR sur its-not-skynet. Le skill enrobe
`scripts/doctor.sh` (lint + catalogue + audit sécurité), traduit les sorties en verdict
actionnable, régénère `CATALOG.md`/`index.json` si désynchronisés, et vérifie les règles
appliquées par la CI (`.github/workflows/validate.yml`) ainsi que le statut ≥ beta exigé
pour une PR. Il rend un « prêt / pas prêt » avec la liste des corrections, sans ouvrir la
PR ni committer à la place de l'utilisateur.

## Installation
Copier le dossier du skill dans le projet cible :
```
.claude/skills/pre-pr-check/SKILL.md
```
Conçu pour s'exécuter **à la racine du repo its-not-skynet** (il s'appuie sur `scripts/`).

## Environnement testé
- Outil : Claude Code
- Usage limité : couvre le flux doctor ; cas de catalogue/audit complexes non tous éprouvés.
