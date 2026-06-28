# Meta — post_tool_use_log_bash

## Source
- Auteur : Anthropic (officiel)
- Statut : **stable**
- Référence : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Contexte d'usage
Journalise chaque commande Bash exécutée par Claude dans `~/.claude/bash-command-log.txt` avec horodatage ISO.
Utile pour auditer ce que Claude a exécuté sur une session.

## Événement
- `PostToolUse` — matcher : `Bash`

## Configuration settings.json
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/post_tool_use_log_bash.sh" }]
      }
    ]
  }
}
```

## Prérequis
- `jq` disponible dans le PATH

## Environnement testé
- Outil : Claude Code
