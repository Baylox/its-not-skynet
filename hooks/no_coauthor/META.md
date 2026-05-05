# Meta — no_coauthor

## Source
- Auteur : Baylo
- Statut : **Créé et validé par le contributeur**

## Contexte d'usage
Bloque toute tentative de commit contenant `Co-Authored-By` dans le message.
Empêche Claude de s'auto-attribuer les commits.

## Événement
- `PostToolUse` — matcher : `Bash`, filtre : `Bash(git commit *)`
- Inspecte le message du commit **après** qu'il a été enregistré — plus fiable que PreToolUse qui analyse la commande brute.

## Configuration settings.json
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "if": "Bash(git commit *)",
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
