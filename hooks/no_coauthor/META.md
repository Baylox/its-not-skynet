# Meta — no_coauthor

## Source
- Auteur : Baylo
- Statut : **Créé et validé par le contributeur**

## Contexte d'usage
Bloque toute tentative de commit contenant `Co-Authored-By` dans le message.
Empêche Claude de s'auto-attribuer les commits.

## Événement
- `PreToolUse` — matcher : `Bash`

## Configuration settings.json
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/no_coauthor/hook.sh\""
          }
        ]
      }
    ]
  }
}
```

## Environnement testé
- Outil : Claude Code
