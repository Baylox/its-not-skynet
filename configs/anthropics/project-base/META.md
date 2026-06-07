# Meta — project-base

## Source
- Auteur : Anthropic (officiel)
- Référence : https://docs.anthropic.com/fr/docs/claude-code/settings

## Contexte d'usage
Configuration projet de base à committer dans `.claude/settings.json`. Définit les permissions git sûres pour toute l'équipe : les lectures courantes sont autorisées sans prompt, les opérations destructives demandent confirmation.

## Installation

Copier vers :
```
.claude/settings.json
```

À committer dans le dépôt pour partager les règles avec l'équipe.

## Ce que ça configure

| Clé | Valeur | Raison |
|-----|--------|--------|
| `permissions.allow` | `git status`, `git log`, `git diff` | Lecture git sans prompt |
| `permissions.ask` | `git push`, `git reset` | Confirmation avant opérations risquées |
| `permissions.deny` | `.env`, `secrets/` | Protection des fichiers sensibles |

## Environnement testé
- Outil : Claude Code
