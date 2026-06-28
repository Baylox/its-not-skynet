# Meta — pre_tool_use_protect_files

## Source
- Auteur : Anthropic (officiel)
- Statut : **stable**
- Référence : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Contexte d'usage
Bloque toute tentative d'édition ou d'écriture sur des fichiers sensibles (`.env`, `package-lock.json`, `.git/`).
Les patterns protégés sont configurables directement dans le script.

## Événement
- `PreToolUse` — matcher : `Edit|Write`
- Exit 2 = blocage avec message dans stderr

## Configuration settings.json
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/pre_tool_use_protect_files.sh" }]
      }
    ]
  }
}
```

## Prérequis
- `jq` disponible dans le PATH

## Personnalisation
Modifier le tableau `PROTECTED_PATTERNS` dans le script pour adapter les fichiers protégés.

## Environnement testé
- Outil : Claude Code
