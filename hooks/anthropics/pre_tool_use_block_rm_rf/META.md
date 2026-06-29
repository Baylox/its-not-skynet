# Meta — pre_tool_use_block_rm_rf

## Source
- Auteur : Anthropic (officiel)
- Statut : **stable**
- Référence : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Contexte d'usage
Bloque toute commande Bash contenant `rm -rf` (ou variantes `-fr`, `-rf`, etc.) avant son exécution.
Prévention de suppressions destructives accidentelles.

## Événement
- `PreToolUse` — matcher : `Bash`
- Exit 2 = blocage avec message dans stderr

## Configuration settings.json
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/pre_tool_use_block_rm_rf.sh" }]
      }
    ]
  }
}
```

## Prérequis
- `jq` disponible dans le PATH

## Environnement testé
- Outil : Claude Code
