# Meta — claude_md_sync

## Source
- Auteur : Baylo
- Statut : **Créé et validé par le contributeur**

## Contexte d'usage
Après chaque `git commit`, vérifie que `CLAUDE.md` et les `README.md` des dossiers `hooks/`, `skills/`, `configs/` sont bien synchronisés avec les fichiers ajoutés ou modifiés.

Évite d'oublier de documenter une nouvelle ressource après l'avoir committée.

## ⚠️ Coût en tokens

Ce hook utilise `type: prompt` — il effectue **un appel LLM à chaque `git commit`**.
Cela consomme des tokens à chaque déclenchement. À activer en connaissance de cause,
notamment dans les sessions à fort volume de commits.

## Événement
- `PostToolUse` — matcher : `Bash`, filtre : `git commit *`
- Type : **prompt** (appel LLM — pas un script shell)

## Installation

Fusionner le contenu de `hook.json` dans votre `settings.json` cible :

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "if": "Bash(git commit *)",
        "hooks": [
          {
            "type": "prompt",
            "statusMessage": "Vérification de la cohérence du CLAUDE.md...",
            "prompt": "Des fichiers ont été commités. Si des ressources ont été ajoutées, déplacées ou supprimées dans hooks/, skills/, ou configs/, vérifie que CLAUDE.md et le README.md du dossier concerné reflètent bien ces changements. Si ce n'est pas le cas, réponds avec {\"continue\": false, \"stopReason\": \"CLAUDE.md ou un README est désynchronisé. Pensez à les mettre à jour avant de continuer.\"}. Sinon réponds avec {\"continue\": true}."
          }
        ]
      }
    ]
  }
}
```

## Environnement testé
- Outil : Claude Code
