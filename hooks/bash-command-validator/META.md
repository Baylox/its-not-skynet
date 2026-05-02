# Meta — bash-command-validator

## Source
- Auteur : Anthropic (officiel)
- Repo : https://github.com/anthropics/claude-code/blob/main/examples/hooks/bash_command_validator_example.py
- Statut : **Validé par source officielle**

## Type
- Événement : PreToolUse
- Handler : command (déterministe)

## Ce que ça fait
Valide les commandes bash avant exécution. Par défaut, bloque `grep` et `find -name` en suggérant `rg` (ripgrep) à la place. Exit code 2 = bloque l'outil et informe Claude. Conçu comme exemple extensible — les règles sont dans `_VALIDATION_RULES`.

> Note : fichier `.sh` mais écrit en Python. Renommer en `.py` si nécessaire.

## Environnement testé
- Outil : Claude Code
- Déclaré compatible : Claude Code
