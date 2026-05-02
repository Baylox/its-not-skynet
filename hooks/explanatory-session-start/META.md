# Meta — explanatory-session-start

## Source
- Auteur : Anthropic (officiel)
- Repo : https://github.com/anthropics/claude-code/blob/main/plugins/explanatory-output-style/hooks-handlers/session-start.sh
- Statut : **Validé par source officielle**

## Type
- Événement : SessionStart
- Handler : command (déterministe)

## Ce que ça fait
Injecte des instructions en début de session pour activer le mode "Explanatory" — Claude fournit des insights éducatifs formatés avant et après chaque bloc de code. Remplace le setting `outputStyle: Explanatory` déprécié.

> ⚠️ Attention : augmente la consommation de tokens à chaque session.

## Environnement testé
- Outil : Claude Code
- Déclaré compatible : Claude Code
