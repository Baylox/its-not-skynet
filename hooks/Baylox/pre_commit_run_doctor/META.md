# Meta — pre_commit_run_doctor

## Source
- Auteur : Baylox
- Statut : **draft**
- Tags : git, validation, dogfooding, CI-locale
- Dépendances : jq

## Contexte d'usage
Hook de dogfooding pour le repo its-not-skynet : avant chaque `git commit`, il exécute
`scripts/doctor.sh` (lint des ressources + catalogue à jour + audit sécurité). Si le doctor
échoue, le commit est **bloqué** (exit 2) et les points ✗ sont affichés. Empêche de
committer une ressource non conforme ou un `CATALOG.md`/`index.json` désynchronisé — les
mêmes contrôles que la CI, mais en local et en amont.

Garde-fou : le hook ne s'active que dans un dépôt qui possède `scripts/doctor.sh`. Dans tout
autre projet, il sort en `0` sans interférer.

## Événement
- `PreToolUse` — matcher : `Bash` (filtre les `git commit`)

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
            "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/Baylox/pre_commit_run_doctor/hook.sh\""
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
