# Meta — hookify-posttooluse

## Source
- Auteur : Anthropic (officiel)
- Repo : https://github.com/anthropics/claude-plugins-official/blob/main/plugins/hookify/hooks/posttooluse.py
- Statut : **Validé par source officielle**

## Type
- Événement : PostToolUse
- Handler : command (déterministe)

## Ce que ça fait
Partie du système Hookify. Évalue des règles configurables après chaque appel d'outil. Même logique que `pretooluse` mais déclenché en sortie d'outil. Dépend de `core/config_loader.py` et `core/rule_engine.py`.

> ⚠️ Ce hook fait partie d'un système de plugins complet. Utiliser seul sans `core/` ne fonctionnera pas.

## Environnement testé
- Outil : Claude Code
- Déclaré compatible : Claude Code
