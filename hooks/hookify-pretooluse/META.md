# Meta — hookify-pretooluse

## Source
- Auteur : Anthropic (officiel)
- Repo : https://github.com/anthropics/claude-plugins-official/blob/main/plugins/hookify/hooks/pretooluse.py
- Statut : **Validé par source officielle**

## Type
- Événement : PreToolUse
- Handler : command (déterministe)

## Ce que ça fait
Partie du système Hookify. Lit les fichiers `.claude/hookify.*.local.md` et évalue des règles configurables avant chaque appel d'outil (`Bash`, `Edit`, `Write`, `MultiEdit`). Dépend de `core/config_loader.py` et `core/rule_engine.py` — nécessite le plugin hookify complet pour fonctionner.

> ⚠️ Ce hook fait partie d'un système de plugins complet. Utiliser seul sans `core/` ne fonctionnera pas.

## Environnement testé
- Outil : Claude Code
- Déclaré compatible : Claude Code
