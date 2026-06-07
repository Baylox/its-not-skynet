# Meta — session_start_reinject_context

## Source
- Auteur : Anthropic (officiel)
- Référence : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Contexte d'usage
Réinjecte des rappels de contexte projet dans la conversation après une compaction automatique.
Utile pour rappeler les conventions (gestionnaire de paquets, règles de commit, sprint en cours, etc.) que Claude aurait perdus lors de la compaction.

## Événement
- `SessionStart` — matcher : `compact`

## Configuration settings.json
```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "compact",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/session_start_reinject_context.sh" }]
      }
    ]
  }
}
```

## Personnalisation
Modifier le message `echo` dans le script pour l'adapter au projet.

## Environnement testé
- Outil : Claude Code
