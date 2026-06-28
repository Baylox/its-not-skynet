# Meta — block_push_main

## Source
- Auteur : Baylox
- Statut : **draft**
- Tags : git, protection, dogfooding
- Dépendances : jq

## Contexte d'usage
Bloque tout `git push` vers `main`/`master` (exit 2). Cohérent avec la règle de branches du
repo : on développe sur une branche dédiée et `main` ne reçoit que des merges via PR. Couvre
les cibles explicites (`git push origin main`, `git push -u origin main`) et le push sans
refspec (`git push`, `git push origin`) lorsque la branche courante est `main`/`master`. Un
push vers une branche de feature n'est jamais bloqué.

## Événement
- `PreToolUse` — matcher : `Bash` (filtre les `git push`)

## Installation
Ajouter dans `settings.json` :
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/Baylox/block_push_main/hook.sh\""
          }
        ]
      }
    ]
  }
}
```

## Environnement testé
- Outil : Claude Code
- À tester en conditions réelles avant passage en `beta`.
