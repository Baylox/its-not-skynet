# Meta — global-base

## Source
- Auteur : Anthropic (officiel)
- Référence : https://docs.anthropic.com/fr/docs/claude-code/settings
- Statut : **Validé par source officielle**

## Contexte d'usage
Configuration globale de base pour Claude Code. Couvre le modèle, la langue, le niveau de réflexion et la protection minimale des fichiers sensibles. Point de départ recommandé avant toute personnalisation.

## Installation

Copier vers :
```
~/.claude/settings.json
```

Fusionner avec votre `settings.json` existant si vous en avez déjà un.

## Ce que ça configure

| Clé | Valeur | Raison |
|-----|--------|--------|
| `model` | `claude-sonnet-4-6` | Bon équilibre vitesse/qualité |
| `alwaysThinkingEnabled` | `true` | Raisonnement approfondi activé |
| `effortLevel` | `high` | Effort maximal par défaut |
| `language` | `français` | Réponses en français |
| `attribution.commit` | `""` | Pas de co-attribution dans les commits |
| `attribution.pr` | `""` | Pas de co-attribution dans les PRs |
| `permissions.deny` | `.env`, `secrets/`, `.aws/` | Protection des fichiers sensibles |

## Environnement testé
- Outil : Claude Code
