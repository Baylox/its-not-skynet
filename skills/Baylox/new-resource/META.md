# Meta — new-resource

## Source
- Auteur : Baylox
- Statut : **beta**
- Tags : contribution, scaffold, méta
- Dépendances : aucune (les scripts du repo suffisent ; `jq` optionnel)

## Contexte d'usage
Skill « contributeur assisté » : à partir de la description d'une ressource, il génère
l'arborescence `<type>/<pseudo>/<nom>` conforme aux conventions du repo. Il appelle
`scripts/new.sh`, remplit le `META.md` (statut `draft`), écrit le fichier de définition
(SKILL.md, hook.sh, config…), met à jour le `README.md` parent et valide via
`scripts/doctor.sh`. Outille le protocole décrit dans la section « Mode contributeur
assisté » du `CLAUDE.md`, sans jamais committer (validation humaine requise).

## Installation
Copier le dossier du skill dans le projet cible :
```
.claude/skills/new-resource/SKILL.md
```
Conçu pour s'exécuter **à la racine du repo its-not-skynet** (il s'appuie sur `scripts/`).

## Environnement testé
- Outil : Claude Code
- Usage limité : edge cases (nouveau contributeur, type non-skill) non tous couverts.
