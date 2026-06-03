# Meta — post_tool_use_prettier

## Source
- Auteur : Anthropic (officiel)
- Référence : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Contexte d'usage
Auto-formate chaque fichier écrit ou édité par Claude via Prettier.
Garantit un style de code cohérent sans intervention manuelle après chaque modification.

## Événement
- `PostToolUse` — matcher : `Edit|Write`

## Configuration settings.json
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/post_tool_use_prettier.sh" }]
      }
    ]
  }
}
```

## Prérequis
- `npx` disponible dans le PATH
- Prettier installé dans le projet ou globalement

## Environnement testé
- Outil : Claude Code
