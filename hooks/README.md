# hooks/

Scripts shell déterministes — aucune logique IA.

## Où les utiliser

Les hooks ne se copient pas directement : ils sont **référencés** dans le `settings.json` du projet cible.

```json
{
  "hooks": {
    "PreToolUse": [{ "command": "bash /chemin/vers/hook.sh" }]
  }
}
```

## Convention

Fichiers en `snake_case`, préfixés par événement — ex: `pre_tool_use_lint.sh`, `post_tool_use_notify.sh`.
