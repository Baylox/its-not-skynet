# Meta — no_coauthor

## Source
- Auteur : Baylo
- Statut : **Créé et validé par le contributeur**

## Contexte d'usage
Bloque toute tentative de commit contenant `Co-Authored-By` dans le message.
Empêche Claude de s'auto-attribuer les commits.

**Deux approches possibles — choisissez l'une ou l'autre :**

| Approche | Quand l'utiliser |
|----------|-----------------|
| Ce hook | Pour partager la règle via un `settings.json` commité dans le repo — s'applique à toute l'équipe sans config personnelle |
| `attribution.commit: ""` dans `~/.claude/settings.json` | Pour une config personnelle globale — natif Claude Code, zéro overhead |

Les deux sont viables. Les combiner est redondant mais inoffensif.

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
