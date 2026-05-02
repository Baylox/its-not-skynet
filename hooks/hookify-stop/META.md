# Meta — hookify-stop

## Source
- Auteur : Anthropic (officiel)
- Repo : https://github.com/anthropics/claude-plugins-official/blob/main/plugins/hookify/hooks/stop.py
- Statut : **Validé par source officielle**

## Type
- Événement : Stop
- Handler : command (déterministe)

## Ce que ça fait
Partie du système Hookify. Évalue des règles configurables au moment où l'agent veut s'arrêter. Permet d'intercepter l'arrêt et d'injecter un message système. Dépend de `core/config_loader.py` et `core/rule_engine.py`.

> ⚠️ Ce hook fait partie d'un système de plugins complet. Utiliser seul sans `core/` ne fonctionnera pas.

## Environnement testé
- Outil : Claude Code
- Déclaré compatible : Claude Code
